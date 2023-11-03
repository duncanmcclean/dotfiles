# ------------------------------------------------------------------------------
# Laravel Valet
# ------------------------------------------------------------------------------

alias v="valet"
alias vi="valet isolate"


# ------------------------------------------------------------------------------
# Composer
# ------------------------------------------------------------------------------

alias c="valet composer"
alias ci="valet composer install"
alias cr="valet composer require"
alias cu="valet composer update"
alias cg="composer global"
alias ray="valet composer require spatie/ray"

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
        valet php ./vendor/bin/pest $@
    elif [ -n "./vendor/bin/phpunit" ]; then
        valet php ./vendor/bin/phpunit $@
    fi
}

alias tf="t --filter"
