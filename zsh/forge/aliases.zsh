# System
alias cl="clear"

# Laravel & Statmic
alias a="php artisan"
alias p="php please"
alias migrate="php artisan migrate"
alias fresh="php artisan migrate:fresh"
alias seed="php artisan db:seed"
alias tinker="php artisan tinker"

# Composer
alias c="composer"
alias uc="php -d memory_limit=-1 /usr/local/bin/composer"

# Node & Yarn
alias n="npm"
alias y="yarn"

# Git
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
alias unstage="git reset"
