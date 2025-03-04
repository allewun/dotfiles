# Copyright (C) 2015 Facebook, Inc
# Maintained by Ryan McElroy <rm@fb.com>
#
# Inspiration and derivation from git-completion.bash by Shawn O. Pearce.
#
# Distributed under the GNU General Public License, version 2.0.
#
# ========================================================================
#
# Quickly determines the and emits some useful information about the state
# of your current mercurial or git repository. Useful for PS1 prompts.
#
# Design goals:
#  * Useful for both git and mercurial
#  * Portable to both zsh and bash
#  * Portable to both Mac (BSD-based utils) and Linux (GNU-based utils)
#  * As fast as possible given the above constraints (few command invocations)
#  * Avoids invoking git or mercurial, which may be slow on large repositories
#
# To use from zsh:
#
#   NOTE! the single quotes are important; if you use double quotes
#   then the prompt won't change when you chdir or checkout different
#   branches!
#
#   setopt PROMPT_SUBST
#   source /path/to/scm-prompt
#   export PS1='$(_scm_prompt)$USER@%m:%~%% '
#
# To use from bash:
#
#   source /path/to/scm-prompt
#   export PS1="\$(_scm_prompt)\u@\h:\W\$ "
#
#   NOTE! You *EITHER* need to single-quote the whole thing *OR* back-slash
#   the $(...) (as above), but not both. Which one you use depends on if
#   you need the rest of your PS1 to interpolate variables.
#
# You may additionally pass a format-string to the scm_info command. This
# allows you to control the format of the prompt string without interfering
# with the prompt outside of a mercurial or git repository. For example:
#
#   $(_scm_prompt "%s")
#
# The default format string is " (%s)" (note the space)
#
# Options: you may want to set these environment variables
#  * HOME_IS_NOT_A_REPO : Stop walking up the filesystem looking for a git or
#    hg repo at (but not including) /home instead of /.  This helps when /home
#    is a remote or autofs mount point.
#  * WANT_OLD_SCM_PROMPT : Use '%s' as the formatting for the prompt instead
#    of ' (%s)'
#
# Notes to developers:
#
#  * Aliases can screw up the default commands. To prevent this issue, use
#    the 'builtin' prefix for built-in shell commands (eg, 'cd' and 'echo')
#    and use the 'command' prefix for external commands that you do not want
#    to invoke aliases for (eg, 'grep', 'cut').
#
# =========================================================================
#

_find_most_relevant() {
    # We don't want to output all remote bookmarks because there can be many
    # of them. This function finds the most relevant remote bookmark using this
    # algorithm:
    # 1. If 'master' or '@' bookmark is available then output it
    # 2. Sort remote bookmarks and output the first in reverse sorted order (
    # it's a heuristic that tries to find the newest bookmark. It will work well
    # with bookmarks like 'release20160926' and 'release20161010').
    relevantbook="$(command grep -m1 -E -o "^[^/]+/(master|@)$" <<< "$1")"
    if [[ -n $relevantbook ]]; then
        builtin echo $relevantbook
        return 0
    fi

    builtin echo "$(command sort -r <<< "$1" | command head -n 1)"
}

__hg_prompt() {
  local hg br extra
  hg="$1"

  if [[ -f "$hg/bisect.state" ]]; then
    extra="|BISECT"
  elif [[ -f "$hg/histedit-state" ]]; then
    extra="|HISTEDIT"
  elif [[ -f "$hg/graftstate" ]]; then
    extra="|GRAFT"
  elif [[ -f "$hg/unshelverebasestate" ]]; then
    extra="|UNSHELVE"
  elif [[ -f "$hg/rebasestate" ]]; then
    extra="|REBASE"
  elif [[ -d "$hg/merge" ]]; then
    extra="|MERGE"
  elif [[ -L "$hg/store/lock" ]]; then
    extra="|STORE-LOCKED"
  elif [[ -L "$hg/wlock" ]]; then
    extra="|WDIR-LOCKED"
  fi
  local dirstate="$( \
    ( [[ -f "$hg/dirstate" ]] && \
    command hexdump -vn 20 -e '1/1 "%02x"' "$hg/dirstate") || \
    builtin echo "empty")"

  local shared_hg="$hg"
  if [[ -f "$hg/sharedpath" ]]; then
    shared_hg="$(command cat $hg/sharedpath)"
  fi
  local remote="$shared_hg/store/remotenames"

  local active="$hg/bookmarks.current"
  if  [[ -f "$active" ]]; then
    br="$(command cat "$active")"
    # check to see if active bookmark needs update (eg, moved after pull)
    local marks="$shared_hg/store/bookmarks"
    if [[ -z "$extra" ]] && [[ -f "$marks" ]]; then
      local markstate="$(command grep " $br$" "$marks" | \
        command cut -f 1 -d ' ')"
      if [[ $markstate != "$dirstate" ]]; then
        extra="|UPDATE_NEEDED"
      fi
    fi
  else
    br="$(builtin echo "$dirstate" | command cut -c 1-8)"
  fi
  if [[ -f "$remote" ]]; then
    local allremotemarks="$(command grep "^$dirstate bookmarks" "$remote" | \
      command cut -f 3 -d ' ')"

    if [[ -n "$allremotemarks" ]]; then
        local remotemark="$(_find_most_relevant "$allremotemarks")"
        if [[ -n "$remotemark" ]]; then
          br="$br|$remotemark"
          if [[ "$remotemark" != "$allremotemarks" ]]; then
            # if there is more than one, let the user know with an elipsis
            br="${br}..."
          fi
        fi
    fi
  fi
  local branch
  if [[ -f "$hg/branch" ]]; then
    branch="$(command cat "$hg/branch")"
    if [[ "$branch" != "default" ]]; then
      br="$br|$branch"
    fi
  fi
  br="$br$extra$(_hg_dirty)"
  builtin printf "%s" "$br"
}

_hg_prompt() {
  local dir fmt br
  # Default to be compatable with __git_ps1. In particular:
  # - provide a space for the user so that they don't have to have
  #   random extra spaces in their prompt when not in a repo
  # - provide parens so it's differentiated from other crap in their prompt
  fmt="${1:-%s}"

  # find out if we're in a git or hg repo by looking for the control dir
  dir="$PWD"
  while : ; do
    [[ -n "$HOME_IS_NOT_A_REPO" ]] && [[ "$dir" = "/home" ]] && break
    if [[ -d "$dir/.hg" ]]; then
      br="$(__hg_prompt "$dir/.hg")"
      break
    fi
    [[ "$dir" = "/" ]] && break
    # portable "realpath" equivalent
    dir="$(realpath "$dir/..")"
  done

  if [[ -n "$br" ]]; then
    builtin printf "$fmt" "$br"
  fi
}

# cf. https://www.internalfb.com/intern/qa/4964/how-do-i-show-the-mercurial-bookmarkgit-branch-in?answerID=540621130023036
_hg_dirty() {
  if [ -n "${SHOW_DIRTY_STATE}" ] &&
     [ "$(hg config shell.showDirtyState)" != "false" ]; then
    command hg status 2> /dev/null \
    | command awk '$1 == "?" { print "?" } $1 != "?" { print "*" }' \
    | command sort | command uniq | command head -c1
  fi
}