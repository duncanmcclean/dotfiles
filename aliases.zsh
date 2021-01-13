# General Shortcuts
alias a="php artisan"
alias p="php please"
alias g="git"
alias c="composer"
alias c1="composer self-update --1"
alias c2="composer self-update && composer self-update --2"
alias ci="composer install"
alias cr="composer require"
alias cu="composer update"
alias uc="php -d memory_limit=-1 /usr/local/bin/composer"
alias cg="composer global"
alias n="npm"
alias y="yarn"
alias tf="t --filter"
alias subl="open -a 'Sublime Text'"
alias dot="cd ~/.dotfiles"

# Bash stuff
alias cl="clear"
alias clearmail=": > /var/mail/$USER"
alias profile="source ~/.zshrc"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy"
alias cleardns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Git
alias add="git add"
alias all="git add ."
alias push="git push"
alias pull="git pull"
alias commit="git commit -m"
alias wip="all && commit 'wip'"
alias check="git checkout"
alias reset="git reset"
alias clone="git clone"
alias init="git init && git add . && git commit -m 'Initial commit'"
alias status="git status"
alias nah="git reset HEAD --hard"

# Laravel
alias migrate="php artisan migrate"
alias fresh="php artisan migrate:fresh"
alias seed="php artisan db:seed"
alias larasetup="composer install && cp .env.example .env && php artisan key:generate && npm install && npm run dev"
alias hor="php artisan horizon"

# Laravel Vapor
alias v="vapor"
alias vdp="vapor deploy production"
alias vds="vapor deploy staging"

# Statamic
alias pls="php please"
alias plsnew="statamic new"
alias plsclear="p stache:clear && p glide:clear && p static:clear && a cache:clear"
alias plsuser="cp ~/.dotfiles/statamic/duncan@mcclean.co.uk.yaml users/duncan@mcclean.co.uk.yaml"
alias plsdeets="php please support:details"
