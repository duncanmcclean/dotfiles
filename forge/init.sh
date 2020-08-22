# Bootstrap Necessary Dotfiles for Laravel Forge server
rm /home/forge/.bash_aliases
ln -s /home/forge/.dotfiles/forge/.bash_aliases /home/forge/.bash_aliases

# Install cross-env globally
sudo npm install -g cross-env