# ------------------------------------------------------------------------------
# Laravel Herd
# ------------------------------------------------------------------------------

alias v="herd"
alias vi="herd isolate"
alias share="~/.dotfiles/bin/cf"


# ------------------------------------------------------------------------------
# Composer
# ------------------------------------------------------------------------------

alias c="herd composer"
alias c1="herd composer self-update --1"
alias c2="herd composer self-update && composer self-update --2"
alias ci="herd composer install"
alias cr="herd composer require"
alias cu="herd composer update"
alias cg="composer global"
alias ray="herd composer require spatie/ray"

# Get version of installed Composer package
compv() {
  if [[ $1 == *"/"* ]]; then
    composer show $1 | grep 'versions' | grep -o -E '\*\ .+' | cut -d' ' -f2 | cut -d',' -f1;
  else
    composer info | grep $1
  fi
}


# ------------------------------------------------------------------------------
# Testing (Pest or PHPUnit, depending on what's available)
# ------------------------------------------------------------------------------

t() {
    if [ -f "./vendor/bin/pest" ]; then
        php -d memory_limit=-1 ./vendor/bin/pest $@
    elif [ -n "./vendor/bin/phpunit" ]; then
        php -d memory_limit=-1 ./vendor/bin/phpunit $@
    fi
}

alias tf="t --filter"
