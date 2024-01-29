alias p="valet php please"
alias pnew="statamic new"
alias puser="cp ~/.dotfiles/statamic/duncan@statamic.com.yaml users/duncan@statamic.com.yaml"
alias puserme="cp ~/.dotfiles/statamic/duncan@duncanmcclean.com.yaml users/duncan@duncanmcclean.com.yaml"
alias pdeets="valet php please support:details"
alias psc="valet php please stache:clear"


# ------------------------------------------------------------------------------
# Setup a fresh Statamic site, ready for development.
# ------------------------------------------------------------------------------

pfresh() {
    cd ~/Code/Statamic
    statamic new $1 --no-interaction
    cd $1
    puser
    osslink statamic/cms ~/Code/Statamic/cms
    init

    echo ""
    echo "Site created at ~/Code/Statamic/$1"
    echo "Site: http://$1.test"
    echo "Control Panel: http://$1.test/cp"
}
