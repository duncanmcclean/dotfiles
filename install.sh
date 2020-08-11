#!/bin/bash
set -euo pipefail

# Display message 'Setting up your Mac...'
echo "Setting up your Mac..."
sudo -v

# Oh My Zsh
echo "Installing Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Configure symlinks
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.mackup.cfg ~/.mackup.cfg

# Homebrew - Installation
echo "Installing Homebrew"

if test ! $(which brew); then
 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install Homebrew Packages
cd ~
echo "Installing Homebrew packages"

homebrew_packages=(
 "git"
 "mysql"
 "php"
 "node"
 "yarn"
 "mackup"
 "go"
)

for homebrew_package in "${homebrew_packages[@]}"; do
 brew install "$homebrew_package"
done

# Install Casks
echo "Installing Homebrew cask packages"

homebrew_cask_packages=(
  "1password"
  "alfred"
  "anydesk"
  "authy"
  "google-backup-and-sync"
  "balenaetcher"
  "chrome-remote-desktop-host"
  "discord"
  "firefox"
  "flux"
  "github"
  "google-chrome"
  "insomnia"
  "iterm2"
  "droplr"
  "obs"
  "opendnsupdater"
  "phpstorm"
  "propresenter"
  "rocket"
  "sketch"
  "slack"
  "spotify"
  "sublime-text"
  "tableplus"
  "telegram"
  "tuple"
  "typora"
  "vlc"
  "zoomus"
)

for homebrew_cask_package in "${homebrew_cask_packages[@]}"; do
  brew cask install "$homebrew_cask_package"
done

# Install Composer
echo "Installing Composer"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install Global Composer Packages
echo "Installing Global Composer Packages"
/usr/local/bin/composer global require laravel/installer laravel/lumen-installer laravel/valet statamic/cli

# Install Laravel Valet
echo "Installing Laravel Valet"
$HOME/.composer/vendor/bin/valet install

# Create Sites directory
echo "Creating a Sites directory"
mkdir $HOME/Sites

# Start MySQL for the first time
echo "Starting MySQL for the first time"
brew services start mysql

# Configure Laravel Valet
cd ~/Sites
valet park && cd ~
echo "Configuring Laravel Valet"
cd ~
valet restart

# Installing Global Node Dependecies
echo "Installing Global Node Dependecies"
npm install -g @vue/cli
npm install -g @nuxt/cli
npm install -g cross-env
npm install -g heroku
npm install -g netlify-cli

# Generate SSH key
echo "Generating SSH keys"
ssh-keygen -t rsa

echo "Copied SSH key to clipboard - You can now add it to Github"
pbcopy < ~/.ssh/id_rsa.pub

# Register the Global Gitignore file
git config --global core.excludesfile $HOME/.dotfiles/.gitignore_global

# Symlinks
ln -s /Users/duncan/.dotfiles/VSCode/settings.json /Users/duncan/Library/Application\ Support/Code/User/settings.json
ln -s /Users/duncan/.dotfiles/VSCode/keybindings.json /Users/duncan/Library/Application\ Support/Code/User/keybindings.json
ln -s /Users/duncan/.dotfiles/VSCode/snippets/ /Users/duncan/Library/Application\ Support/Code/User

# Hide 'Last Logged In' in terminal
touch .hushlogin

# Complete
echo "Installation Complete"