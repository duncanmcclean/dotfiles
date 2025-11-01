# ------------------------------------------------------------------------------
# Fork, clone and install dependencies
# ------------------------------------------------------------------------------

oss() {
    GH_REPO=$1
    PACAKGE_VENDOR=`echo $1 | cut -d"/" -f1`
    PACKAGE_NAME=`echo $1 | cut -d"/" -f2`
    CLONE_LOCATION=~/Code/OpenSource/$PACKAGE_NAME

    # Fork & clone repo
    gh repo fork $GH_REPO $CLONE_LOCATION --remote=true --clone=true

    # Change directory into fork
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