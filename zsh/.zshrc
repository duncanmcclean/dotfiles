export DOTFILES="$HOME/.dotfiles"
export ZSH="$HOME/.oh-my-zsh"


# ------------------------------------------------------------------------------
# Zsh Config
# ------------------------------------------------------------------------------

ZSH_THEME="agnoster"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
HIST_STAMPS="dd/mm/yyyy"
ZSH_CUSTOM=$DOTFILES/zsh
plugins=(git)

source $ZSH/oh-my-zsh.sh


# ------------------------------------------------------------------------------
# Paths
# ------------------------------------------------------------------------------

export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH=$PATH:/usr/local/mysql/bin/
export PATH=/usr/local/bin:$PATH
export PATH="$PATH:$HOME/mys"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

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

# Run PHPUnit or Pest tests (depending on available runners in project)
t() {
  if [ -f "./vendor/bin/pest" ]; then
    php -d memory_limit=-1 ./vendor/bin/pest $@
  elif [ -n "./vendor/bin/phpunit" ]; then
    php -d memory_limit=-1 ./vendor/bin/phpunit $@
  fi
}

# Script that does all the Statamic/Laravel setup nonsense
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

# Get composer version
compv() {
  if [[ $1 == *"/"* ]]; then
    composer show $1 | grep 'versions' | grep -o -E '\*\ .+' | cut -d' ' -f2 | cut -d',' -f1;
  else
    composer info | grep $1
  fi
}


# ------------------------------------------------------------------------------
# Node Version Manager (NVM)
# ------------------------------------------------------------------------------

if [[ hostname == "Steadfast-Mac-3.local" ]]; then
    export NVM_DIR="$HOME/.nvm"
        [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
        [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi
