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


# ------------------------------------------------------------------------------
# Lines of code on a project
# ------------------------------------------------------------------------------

lines() {
  git ls-files | xargs -n1 git blame --line-porcelain | sed -n 's/^author //p' | sort -f | uniq -ic | sort -nr
}
