# ------------------------------------------------------------------------------
# System
# ------------------------------------------------------------------------------

alias cl="clear"
alias profile="source ~/.zshrc"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy"
alias cleardns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias hosts="sudo nano /etc/hosts"


# ------------------------------------------------------------------------------
# Finder
# ------------------------------------------------------------------------------

alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"


# ------------------------------------------------------------------------------
# General Stuffz
# ------------------------------------------------------------------------------

alias a="valet php artisan"
alias p="valet php please"
alias c="valet composer"
alias c1="valet composer self-update --1"
alias c2="valet composer self-update && composer self-update --2"
alias ci="valet composer install"
alias cr="valet composer require"
alias cu="valet composer update"
alias cg="composer global"
alias n="npm"
alias tf="t --filter"
alias redflush="redis-cli flushall"
alias ray="composer require spatie/ray"


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
# Git
# ------------------------------------------------------------------------------

alias add="git add"
alias all="git add ."
alias fpush="git push -u origin HEAD" # first push, might want to combine this and `push` at some point
alias push="git push"
alias pull="git pull"
alias commit="git commit -m"
alias empty="git commit --allow-empty"
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

alias migrate="valet php artisan migrate"
alias fresh="valet php artisan migrate:fresh"
alias seed="valet php artisan db:seed"
alias hor="valet php artisan horizon"
alias dusk="valet php artisan dusk"
alias duskf="dusk --filter"


# ------------------------------------------------------------------------------
# Statamic
# ------------------------------------------------------------------------------

alias pls="valet php please"
alias plsnew="statamic new"
alias plsuser="cp ~/.dotfiles/statamic/duncan@duncanmcclean.com.yaml users/duncan@duncanmcclean.com.yaml"
alias plsdeets="valet php please support:details"


# ------------------------------------------------------------------------------
# NPM
# ------------------------------------------------------------------------------

alias ni="npm install"
alias dev="npm run dev"
alias watch="npm run watch"
alias prod="npm run production"
alias build="npm run build"


# ------------------------------------------------------------------------------
# Project Shortcuts
# ------------------------------------------------------------------------------

alias home="cd ~"
alias sites="cd ~/Sites"
alias proj="cd ~/Projects"
alias dots="cd ~/.dotfiles"
