# ------------------------------------------------------------------------------
# Link `~/Sites/cms` to current site
# ------------------------------------------------------------------------------

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


# ------------------------------------------------------------------------------
# Link `~/Sites/simple-commerce` to current site
# ------------------------------------------------------------------------------

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


# ------------------------------------------------------------------------------
# Run Test Suite (Pest or PHPUnit, depending on what's available)
# ------------------------------------------------------------------------------

t() {
  if [ -f "./vendor/bin/pest" ]; then
    php -d memory_limit=-1 ./vendor/bin/pest $@
  elif [ -n "./vendor/bin/phpunit" ]; then
    php -d memory_limit=-1 ./vendor/bin/phpunit $@
  fi
}


# ------------------------------------------------------------------------------
# Setup all the things for a Laravel/Statamic app
# ------------------------------------------------------------------------------

plssetup() {
  composer install
  cp .env.example .env
  php artisan key:generate
  npm install
  npm run dev

  if [ -f "please" ]; then
    plsuser
  fi
}


# ------------------------------------------------------------------------------
# Get version of installed Composer package
# ------------------------------------------------------------------------------

compv() {
  if [[ $1 == *"/"* ]]; then
    composer show $1 | grep 'versions' | grep -o -E '\*\ .+' | cut -d' ' -f2 | cut -d',' -f1;
  else
    composer info | grep $1
  fi
}

# TODO: fix comment
# clone one of my repos
cloneme() {
  git clone git@github.com:duncanmcclean/$1.git
}
