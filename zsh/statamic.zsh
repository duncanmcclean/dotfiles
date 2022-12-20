alias pnew="statamic new"
alias puser="cp ~/.dotfiles/statamic/duncan@duncanmcclean.com.yaml users/duncan@duncanmcclean.com.yaml"
alias pdeets="valet php please support:details"


# ------------------------------------------------------------------------------
# Setup all the things for a Laravel/Statamic app
# ------------------------------------------------------------------------------

plssetup() {
  valet isolate php@8.1
  composer install
  cp .env.example .env
  php artisan key:generate
  npm install
  npm run dev

  if [ -f "please" ]; then
    puser
  fi
}
