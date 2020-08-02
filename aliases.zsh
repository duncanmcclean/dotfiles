# General Shortcuts
alias a="php artisan"
alias p="php please"
alias g="git"
alias t="./vendor/bin/phpunit"
alias c="composer"
alias ci="composer install"
alias cr="composer require"
alias cu="composer update"
alias uc="php -d memory_limit=-1 /usr/local/bin/composer"
alias n="npm"
alias y="yarn"
alias pstorm='open -a /Applications/PhpStorm.app "`pwd`"'
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

# Laravel
alias migrate="php artisan migrate"
alias fresh="php artisan migrate:fresh"
alias seed="php artisan db:seed"

# Statamic
alias pls="php please"
alias plsnew="composer create-project statamic/statamic $1 --prefer-dist --stability=dev"
alias plsclear="pls clear:cache && pls clear:stache && pls clear:static && pls clear:glide"
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