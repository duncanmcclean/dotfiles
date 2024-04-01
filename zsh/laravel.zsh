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
alias seed="a db:seed"
alias hor="a horizon"
alias acc="a cache:clear"
alias fresh="a migrate:fresh"
alias rollback="a migrate:rollback"
