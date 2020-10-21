# General Shortcuts
alias a="php artisan"
alias p="php please"
alias g="git"
alias t="php -d memory_limit=-1 ./vendor/bin/phpunit"
alias pe="php -d memory_limit=-1 ./vendor/bin/pest"
alias c="composer"
alias ci="composer install"
alias cr="composer require"
alias cu="composer update"
alias uc="php -d memory_limit=-1 /usr/local/bin/composer"
alias cg="composer global"
alias n="npm"
alias y="yarn"
alias pstorm='open -a /Applications/PhpStorm.app "`pwd`"'
alias subl="open -a 'Sublime Text'"
alias reb="comp install && rm -rf node_modules && npm install && npm run dev"

# Bash stuff
alias cl="clear"
alias clearmail=": > /var/mail/$USER"
alias profile="source ~/.zshrc"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy"

# Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Mac Apps
if [[ $OSTYPE == darwin* ]]; then
    alias slack="open -a /Applications/Slack.app"
    alias chrome="open -a /Applications/Google\ Chrome.app"
fi

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
alias plsnew="composer create-project statamic/statamic $1 --prefer-dist --stability=dev"
alias plsclear="p stache:clear && p glide:clear && p static:clear && a cache:clear"
alias plsuser="cp ~/.dotfiles/statamic/duncan@mcclean.co.uk.yaml users/duncan@mcclean.co.uk.yaml"

# Link sites/cms to current site
# To link cms: plslink cms
# To link dist: plslink dist
plslink() {
  if [ "$1" = 'dist' ] || [ "$1" = 'cp' ]; then
    rm -rf public/vendor/statamic/cp
    ln -s ~/Sites/cms/resources/dist public/vendor/statamic/cp
  elif [ -n "$1" ]; then
    rm -rf vendor/statamic/$1
    ln -s ~/Sites/$1 vendor/statamic/$1
  fi

  echo "\nIn vendor/statamic:"
  la vendor/statamic
  echo "\nIn public/vendor/statamic:"
  la public/vendor/statamic
}

simplink() {
  if [ "$1" = 'dist' ] || [ "$1" = 'cp' ]; then
    rm -rf public/vendor/simple-commerce
    ln -s ~/Sites/simple-commerce/resources/dist public/vendor/simple-commerce
  elif [ -n "$1" ]; then
    rm -rf vendor/doublethreedigital/$1
    ln -s ~/Sites/$1 vendor/doublethreedigital/$1
  fi

  echo "\nIn vendor/doublethreedigital:"
  la vendor/doublethreedigital
  echo "\nIn public/vendor/simple-commerce:"
  la public/vendor/simple-commerce
}
