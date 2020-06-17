# 🚥 dotfiles

- macOS 10.14.6
- zsh 5.7.1

##  Setup

### Pre-requisites

1. Install [Homebrew](https://brew.sh/)
2. Install [iTerm2](https://iterm2.com/)
3. Install [Sublime Text](https://www.sublimetext.com/)
4. Generate SSH key
   ```
   $ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```
   - [Autoload SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent) (`~/.ssh/config`)
      ```
      Host *
        AddKeysToAgent yes
        UseKeychain yes
        IdentityFile ~/.ssh/id_rsa
      ```

### dotfiles setup

```
$ git clone git@github.com:allewun/dotfiles.git ~/dotfiles
$ ./setup.sh
```

### Per-app settings

1. iTerm - `~/dotfiles/preferences/iTerm2/com.googlecode.iterm2.plist`
2. [BetterTouchTool](https://folivora.ai/) - `~/dotfiles/preferences/BetterTouchTool/allen.bttpreset`
3. [Karabiner-Elements](https://karabiner-elements.pqrs.org/) - `~/dotfiles/preferences/Karabiner`
4. [iStat Menus](https://bjango.com/mac/istatmenus/) - `~/dotfiles/preferences/iStat Menus/iStat Menus Settings.ismp`

### Private 🔐

```
$ git clone git@github.com:allewun/dotfiles-private.git ~/dotfiles-private
```