# 🚥 dotfiles

- macOS 10.14.6
- zsh 5.7.1

##  Setting up a new machine

1. Install [Homebrew](https://brew.sh/)
2. Install [iTerm2](https://iterm2.com/)
3. Install [Sublime Text](https://www.sublimetext.com/)
4. Generate SSH key
   ```
   $ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```
   - [Autoload SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent)
      ```
      Host *
        AddKeysToAgent yes
        UseKeychain yes
        IdentityFile ~/.ssh/id_rsa
      ```
5. ```
   $ git clone git@github.com:allewun/dotfiles.git ~/dotfiles
   $ ./setup.sh
   ```
