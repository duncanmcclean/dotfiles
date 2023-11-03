# ------------------------------------------------------------------------------
# Artisan
# ------------------------------------------------------------------------------

a() {
    if [ -f ./artisan ]; then
        valet php artisan $@
    else
        valet php vendor/bin/testbench $@
    fi
}

alias migrate="a migrate"
alias rollback="a migrate:rollback"
alias fresh="a migrate:fresh"
alias seed="a db:seed"
alias hor="a horizon"
