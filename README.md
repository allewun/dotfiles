# 🚥 dotfiles

- macOS 14.1.2
- zsh 5.9

##  Setup

### Pre-requisites

1. Install [Homebrew](https://brew.sh/)
   ```
   # installing here to prevent conflict with system binaries
   $ git clone https://github.com/Homebrew/brew ~/homebrew
   ```
2. Install [iTerm2](https://iterm2.com/)
3. Install [Sublime Text](https://www.sublimetext.com/)
4. Setup SSH key
   ```
   $ ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
   - [Autoload SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent) (`~/.ssh/config`)
      ```
      Host *
        AddKeysToAgent yes
        IgnoreUnknown UseKeychain
        UseKeychain yes
        IdentityFile ~/.ssh/id_ed25519
      ```
   - Add to keychain
      ```
      ssh-add --apple-use-keychain ~/.ssh/id_ed25519
      ```

### dotfiles setup

```
$ git clone git@github.com:allewun/dotfiles.git ~/dotfiles
$ export DOTFILE_PATH=~/dotfiles # this env var is used in several setup scripts, but it's loaded in .zshrc
$ ./setup.sh

...

# data migration:
#   ~/.zsh_history
#   ~/Library/autojump/autojump.txt
```

### Per-app settings

1. iTerm - `~/dotfiles/preferences/iTerm2/com.googlecode.iterm2.plist`
2. [BetterTouchTool](https://folivora.ai/) - `~/dotfiles/preferences/BetterTouchTool/allen.bttpreset`
3. [Karabiner-Elements](https://karabiner-elements.pqrs.org/) - `~/dotfiles/preferences/Karabiner`
4. [iStat Menus](https://bjango.com/mac/istatmenus/) - `~/dotfiles/preferences/iStat Menus/iStat Menus Settings.ismp`

### Private 🙈

```
$ git clone git@github.com:allewun/dotfiles-private.git ~/dotfiles-private
```

## Essential Apps

- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Dropbox](https://www.dropbox.com/)
- [1Password 7](https://app-updates.agilebits.com/product_history/OPM7)
- [Karabiner](https://karabiner-elements.pqrs.org/)
- [Yoink](https://eternalstorms.at/yoink/mac/index.html)
- [Bartender](https://www.macbartender.com/)
- [Timing](https://timingapp.com/)
- [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12)
- [DaisyDisk](https://daisydiskapp.com/)
- [Dash](https://kapeli.com/dash)
