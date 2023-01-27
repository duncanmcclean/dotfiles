alias migrate="valet php artisan migrate"
alias fresh="valet php artisan migrate:fresh"
alias seed="valet php artisan db:seed"
alias hor="valet php artisan horizon"
alias dusk="valet php artisan dusk"
alias duskf="dusk --filter"

function tpo() {
  if [ -d '/Applications/TablePlus.app' ]; then
    TP_DRIVER=$(grep -m1 DB_CONNECTION .env | cut -d '=' -f2)
    TP_HOST=$(grep -m1 DB_HOST .env | cut -d '=' -f2)
    TP_USER=$(grep -m1 DB_USERNAME .env | cut -d '=' -f2)
    TP_PASSWORD=$(grep -m1 DB_PASSWORD .env | cut -d '=' -f2)
    TP_DATABASE=$(grep -m1 DB_DATABASE .env | cut -d '=' -f2)

    if [ $DRIVER = "sqlite" ]; then
      open $TP_DATABASE
    else
      open $TP_DRIVER://$TP_USRE:$TP_PASSWORD@$TP_HOST/$TP_DATABASE
    fi
  else
    echo "This command uses TablePlus, are you sure it's installed?"
    echo "Install here: https://tableplus.com/"
  fi
}
