#!/bin/bash

# Display message 'Setting up your Mac...'
echo "Setting up your Mac..."
sudo -v

# Update package manager
echo "Updating package manager"
sudo apt-get update

# Install packages
echo "Installing packages"
apt_packages=(
  "php"
  "composer"
  "nodejs"
  "npm"
  "git"
  "sqlite"
  "network-manager"
  "libnss3-tools"
  "jq"
  "xsel"
  "php7.2-cli"
  "php7.2-curl"
  "php7.2-mbstring"
  "php7.2-mcrypt"
  "php7.2-xml"
  "php7.2-zip"
  "php7.2-sqlite3"
  "php7.2-mysql"
)

for package in "${apt_packages[@]}"; do
  sudo apt-get install "$package" -y
done

# Install Global Composer Packages
echo "Installing Global Composer Packages"
/usr/local/bin/composer global require laravel/installer cpriego/valet-linux statamic/cli

# Install Laravel Valet
echo "Installing Laravel Valet"
$HOME/.composer/vendor/bin/valet install

# Create Sites directory
echo "Creating a Sites directory"
mkdir $HOME/Sites

# Configure Laravel Valet
cd ~/Sites
valet park
systemctl restart php-fpm

# Installing Global Node Dependecies
echo "Installing Global Node Dependecies"
npm install -g @vue/cli
npm install -g jovo-cli
npm install -g ask-cli


# Generate SSH key
echo "Generating SSH keys"
ssh-keygen -t rsa
eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_rsa

echo "Copied SSH key to clipboard - You can now add it to Github"
pbcopy < ~/.ssh/id_rsa.pub

# Complete
echo "Installation Complete"
