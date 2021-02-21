oss() {
    GH_REPO=$1
    # read PACAKGE_VENDOR PACKAGE_NAME <<<$(IFS="/"; echo $GH_REPO)
    PACAKGE_VENDOR='statamic'
    PACKAGE_NAME='migrator'

    if [ $# -eq 2 ]; then
        CLONE_LOCATION=$PWD/$2
    else
        CLONE_LOCATION=~/Sites/$PACKAGE_NAME
    fi

    # Fork repo
    gh repo fork $GH_REPO $CLONE_LOCATION --remote=true --clone=true

    # Cd into Fork
    cd $CLONE_LOCATION

    # Install Composer dependencies (for tests)
    if [ -f "composer.json" ]; then
        composer install
    fi

    # Install any NPM dependencies
    if [ -f "package.json" ]; then
        npm install
        npm run dev
    fi
}
