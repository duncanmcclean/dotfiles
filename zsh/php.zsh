# ------------------------------------------------------------------------------
# Laravel Valet
# ------------------------------------------------------------------------------

alias v="valet"
alias vi="valet isolate"


# ------------------------------------------------------------------------------
# Artisan & Please
# ------------------------------------------------------------------------------

alias a="valet php artisan"
alias p="valet php please"


# ------------------------------------------------------------------------------
# Composer
# ------------------------------------------------------------------------------

alias c="valet composer"
alias c1="valet composer self-update --1"
alias c2="valet composer self-update && composer self-update --2"
alias ci="valet composer install"
alias cr="valet composer require"
alias cu="valet composer update"
alias cg="composer global"
alias ray="composer require spatie/ray"

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
