# ------------------------------------------------------------------------------
# Artisan
# ------------------------------------------------------------------------------

a() {
    if [ -f ./artisan ]; then
        herd php artisan $@
    else
        herd php vendor/bin/testbench $@
    fi
}

alias migrate="a migrate"
alias fresh="a migrate:fresh"
alias seed="a db:seed"
alias hor="a horizon"
alias dusk="a dusk"
alias duskf="a dusk --filter"


# ------------------------------------------------------------------------------
# Laravel Sail
# ------------------------------------------------------------------------------

alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
alias saila="sail artisan"
