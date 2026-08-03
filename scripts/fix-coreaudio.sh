#!/bin/bash
# Diagnose and fix the coreaudiod <-> audioaccessoryd XPC livelock.
#
# Cause: each logged-in console session runs its own audioaccessoryd, but
# com.apple.BTAudioHALPluginAccessories is a singleton slot in coreaudiod.
# With fast user switching, two instances fight over it forever -- each
# registration kicks the other out, and the loser retries in ~18ms despite
# logging "wait to re-try activation for 3 min". coreaudiod re-enumerates USB
# audio routes every cycle, burning a full core and leaking memory.
#
# Fix: kill the audioaccessoryd stuck in the retry loop. It is launch-on-demand
# and respawns when an audio accessory actually needs it.
#
# Usage: fix-coreaudio [-n] [-a]
#   -n  diagnose only, change nothing
#   -a  also restart coreaudiod to reclaim leaked memory (brief audio glitch)

set -uo pipefail

DRY_RUN=0
RESTART_CA=0
while getopts "nah" opt; do
  case $opt in
    n) DRY_RUN=1 ;;
    a) RESTART_CA=1 ;;
    h) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "usage: $(basename "$0") [-n] [-a]" >&2; exit 2 ;;
  esac
done

SAMPLE_SECS=5
CPU_THRESHOLD=50   # percent
LOOP_THRESHOLD=50  # registrations during SAMPLE_SECS

ca_pid=$(pgrep -x coreaudiod | head -1)
if [[ -z "$ca_pid" ]]; then
  echo "coreaudiod is not running (unusual, but nothing to fix)."
  exit 0
fi

# ps %CPU on macOS is a decaying average; good enough to gate on.
ca_cpu=$(ps -o %cpu= -p "$ca_pid" | tr -d ' ')
ca_mem_mb=$(( $(ps -o rss= -p "$ca_pid" | tr -d ' ') / 1024 ))

echo "coreaudiod (pid $ca_pid): ${ca_cpu}% CPU, ${ca_mem_mb} MB RSS"

if ! awk -v c="$ca_cpu" -v t="$CPU_THRESHOLD" 'BEGIN{exit !(c>t)}'; then
  echo "CPU is below ${CPU_THRESHOLD}% -- livelock not active. Nothing to do."
  [[ $ca_mem_mb -gt 300 ]] && echo "Note: RSS is high (${ca_mem_mb} MB), likely leaked from a past episode. Re-run with -a to reclaim."
  exit 0
fi

echo "Sampling audioaccessoryd for ${SAMPLE_SECS}s to confirm the livelock..."
log_out=$(/usr/bin/log show --last "${SAMPLE_SECS}s" \
  --predicate 'process == "audioaccessoryd"' --style compact 2>/dev/null)

regs=$(grep -c 'Registration to coreaudiod succeeded' <<<"$log_out")
echo "  re-registrations in ${SAMPLE_SECS}s: $regs"

if [[ "$regs" -lt "$LOOP_THRESHOLD" ]]; then
  cat <<EOF

coreaudiod is busy but NOT in the audioaccessoryd livelock (only $regs
re-registrations). Something else is driving it. Investigate with:

  sudo sample $ca_pid 5
  /usr/bin/log show --last 1m --predicate 'process == "coreaudiod"' --style compact

Not killing anything.
EOF
  exit 1
fi

# Identify the offender: the audioaccessoryd emitting the most loop lines.
culprit=$(grep -o 'audioaccessoryd\[[0-9]*' <<<"$log_out" \
          | grep -o '[0-9]*' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')

if [[ -z "$culprit" ]]; then
  echo "Could not identify the looping audioaccessoryd pid. Aborting." >&2
  exit 1
fi

owner=$(ps -o user= -p "$culprit" | tr -d ' ')
echo "  culprit: audioaccessoryd pid $culprit (user: $owner)"

# Report the contending sessions -- the real root cause.
others=$(pgrep -x audioaccessoryd | grep -v "^${culprit}$" | tr '\n' ' ')
[[ -n "${others// }" ]] && echo "  other audioaccessoryd instances: ${others% }"

if [[ $DRY_RUN -eq 1 ]]; then
  echo
  echo "[dry run] would kill $culprit"
  exit 0
fi

echo "Killing audioaccessoryd pid $culprit..."
if [[ "$owner" == "$(id -un)" ]]; then
  kill "$culprit"
else
  echo "  (owned by $owner, needs sudo)"
  sudo kill "$culprit"
fi

sleep 5

new_cpu=$(ps -o %cpu= -p "$ca_pid" 2>/dev/null | tr -d ' ')
if [[ -z "$new_cpu" ]]; then
  echo "coreaudiod exited and is respawning; audio should settle shortly."
  exit 0
fi

echo "coreaudiod now: ${new_cpu}% CPU"

if awk -v c="$new_cpu" -v t="$CPU_THRESHOLD" 'BEGIN{exit !(c>t)}'; then
  cat <<EOF

Still high. The other session's audioaccessoryd is probably now looping.
Durable fix is to log out the extra console session:

$(who | grep console | sed 's/^/  /')

Or re-run this script to kill the new offender.
EOF
  exit 1
fi

echo "Fixed."

if [[ $RESTART_CA -eq 1 ]]; then
  mb=$(( $(ps -o rss= -p "$ca_pid" | tr -d ' ') / 1024 ))
  echo "Restarting coreaudiod to reclaim ${mb} MB (brief audio glitch)..."
  sudo killall coreaudiod
  sleep 3
  np=$(pgrep -x coreaudiod | head -1)
  echo "coreaudiod respawned as pid ${np:-?}, $(( $(ps -o rss= -p "$np" | tr -d ' ') / 1024 )) MB RSS"
fi
