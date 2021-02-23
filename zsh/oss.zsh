# Fork, clone and install deps
oss() {
    GH_REPO=$1
    PACAKGE_VENDOR=`echo $1 | cut -d"/" -f1`
    PACKAGE_NAME=`echo $1 | cut -d"/" -f2`

    if [ $# -eq 2 ]; then
        CLONE_LOCATION=$PWD/$2
    else
        CLONE_LOCATION=~/Sites/$PACKAGE_NAME
    fi

    # Fork & clone repo
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

# Install package
osslink() {
    GH_REPO=$1
    PACAKGE_VENDOR=`echo $1 | cut -d"/" -f1`
    PACKAGE_NAME=`echo $1 | cut -d"/" -f2`

    if [ $# -eq 2 ]; then
        CLONE_LOCATION=$PWD/$2
    else
        CLONE_LOCATION=~/Sites/$PACKAGE_NAME
    fi

    # vendor symlink
    rm -rf vendor/$PACAKGE_VENDOR/$PACKAGE_NAME
    ln -s $CLONE_LOCATION vendor/$PACAKGE_VENDOR/$PACKAGE_NAME
    la vendor/$PACAKGE_VENDOR

    # public/vendor symlink
    if [ -f "resources/dist" ]; then
        rm -rf public/vendor/$PACAKGE_VENDOR
        ln -s $CLONE_LOCATION/resources/dist public/vendor/$PACAKGE_VENDOR
        la public/vendor/$PACAKGE_VENDOR
    fi
}
