# ------------------------------------------------------------------------------
# General Shortcuts
# ------------------------------------------------------------------------------

alias a="valet php artisan"
alias p="valet php please"
alias g="git"
alias c="valet composer"
alias c1="valet composer self-update --1"
alias c2="valet composer self-update && composer self-update --2"
alias ci="valet composer install"
alias cr="valet composer require"
alias cu="valet composer update"
alias uc="valet php -d memory_limit=-1 /usr/local/bin/composer"
alias cg="composer global"
alias n="npm"
alias y="yarn"
alias tf="t --filter"
alias dot="cd ~/.dotfiles"
alias rfa="redis-cli flushall"
alias swh="stripe listen --forward-to"

# ------------------------------------------------------------------------------
# Laravel Valet
# ------------------------------------------------------------------------------

alias v="valet"
alias sv="valet use"
alias p81="valet use php@8.1 && composer global update"
alias p81f="valet use php@8.1 --force"
alias p8="valet use php@8.0 && composer global update"
alias p8f="valet use php@8.0 --force"
alias p74="valet use php@7.4 && composer global update"
alias p74f="valet use php@7.4 --force"

# ------------------------------------------------------------------------------
# System
# ------------------------------------------------------------------------------

alias cl="clear"
alias clearmail=": > /var/mail/$USER"
alias profile="source ~/.zshrc"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy"
alias cleardns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias syms="find . -maxdepth 1 -type l"
alias hosts="sudo nano /etc/hosts"


# ------------------------------------------------------------------------------
# Finder
# ------------------------------------------------------------------------------

alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"


# ------------------------------------------------------------------------------
# Git
# ------------------------------------------------------------------------------

alias add="git add"
alias all="git add ."
alias fpush="git push -u origin HEAD" # first push, might want to combine this and `push` at some point
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
alias diff="git diff"


# ------------------------------------------------------------------------------
# Laravel
# ------------------------------------------------------------------------------

alias migrate="php artisan migrate"
alias fresh="php artisan migrate:fresh"
alias seed="php artisan db:seed"
alias larasetup="composer install && cp .env.example .env && php artisan key:generate && npm install && npm run dev"
alias hor="php artisan horizon"
alias ray="composer require spatie/ray"


# ------------------------------------------------------------------------------
# Laravel Vapor
# ------------------------------------------------------------------------------

alias vp="vapor"
alias vdp="vapor deploy production"
alias vds="vapor deploy staging"


# ------------------------------------------------------------------------------
# Statamic
# ------------------------------------------------------------------------------

alias pls="php please"
alias plsnew="statamic new"
alias plsclear="p stache:clear && p glide:clear && p static:clear && a cache:clear"
alias plsuser="cp ~/.dotfiles/statamic/duncan@mcclean.co.uk.yaml users/duncan@mcclean.co.uk.yaml"
alias plsdeets="php please support:details"

# ------------------------------------------------------------------------------
# NPM
# ------------------------------------------------------------------------------

alias ni="npm install"
alias dev="npm run dev"
alias watch="npm run watch"
alias prod="npm run production"


# ------------------------------------------------------------------------------
# Project Shortcuts
# ------------------------------------------------------------------------------

alias home="cd ~"
alias sites="cd ~/Sites"
alias proj="cd ~/Projects"
alias dots="cd ~/.dotfiles"
