# Shortcuts
alias a="php artisan"
alias p="php please"
alias g="git"
alias t="./vendor/bin/phpunit"
alias c="composer"
alias ci="composer install"
alias cr="composer require"
alias n="npm"
alias y="yarn"
alias pstorm='open -a /Applications/PhpStorm.app "`pwd`"'
alias cl="clear"
alias st="composer create-project statamic/statamic $1 --prefer-dist --stability=dev"

# Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Git
alias add="git add"
alias all="git add ."
alias push="git push"
alias pull="git pull"
alias commit="git commit -m"
alias check="git checkout"
alias branch="git branch"
alias reset="git reset"
alias clone="git clone"
alias init="git init && git add . && git commit -m 'Initial commit'"

# Other
alias migrate="php artisan migrate"
alias fresh="php artisan migrate:fresh"
alias seed="php artisan db:seed"
alias clearmail=": > /var/mail/$USER"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy"
alias test="phpunit"
alias pls="php please"
alias profile="source ~/.zshrc"