# System
alias cl="clear"
alias hello="echo Hiya"

# Laravel & Statmic
alias a="php artisan"
alias p="php please"
alias migrate="php artisan migrate"
alias fresh="php artisan migrate:fresh"
alias seed="php artisan db:seed"

# Composer
alias c="composer"
alias uc="php -d memory_limit=-1 /usr/local/bin/composer"

# Node & Yarn
alias n="npm"
alias y="yarn"

# Git
alias add="git add"
alias all="git add ."
alias push="git push"
alias pull="git pull"
alias commit="git commit -m"
alias wip="all && commit 'wip'"
alias check="git checkout"
alias newbr="git checkout -b"
alias branch="git branch"
alias reset="git reset"
alias clone="git clone"
alias init="git init && git add . && git commit -m 'Initial commit'"
alias status="git status"
alias diff="git diff -w"