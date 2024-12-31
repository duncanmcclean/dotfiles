# ------------------------------------------------------------------------------
# Composer
# ------------------------------------------------------------------------------

alias c="composer"
alias ci="composer install"
alias cr="composer require"
alias cu="composer update"
alias cg="composer global"
alias ray="composer require spatie/laravel-ray"

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
        php ./vendor/bin/pest $@
    elif [ -n "./vendor/bin/phpunit" ]; then
        php ./vendor/bin/phpunit $@
    fi
}

alias tf="t --filter"
