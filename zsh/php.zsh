# ------------------------------------------------------------------------------
# Composer
# ------------------------------------------------------------------------------

alias c="herd composer"
alias ci="herd composer install"
alias cr="herd composer require"
alias cu="herd composer update"
alias cg="herd composer global"
alias ray="herd composer require spatie/laravel-ray"

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
        herd php ./vendor/bin/pest $@
    elif [ -n "./vendor/bin/phpunit" ]; then
        herd php ./vendor/bin/phpunit $@
    fi
}

alias tf="t --filter"
