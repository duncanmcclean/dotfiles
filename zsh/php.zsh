# ------------------------------------------------------------------------------
# Composer
# ------------------------------------------------------------------------------

alias c="herd composer"
alias ci="c install"
alias cr="c require"
alias cu="c update"
alias cg="c global"
alias ray="c require spatie/laravel-ray"
alias pif="./vendor/bin/pint"

# Get version of installed Composer package
compv() {
  if [[ $1 == *"/"* ]]; then
    c show $1 | grep 'versions' | grep -o -E '\*\ .+' | cut -d' ' -f2 | cut -d',' -f1;
  else
    c info | grep $1
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
