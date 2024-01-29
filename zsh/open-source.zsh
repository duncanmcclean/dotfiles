# ------------------------------------------------------------------------------
# Helper function for figuring out where to clone the repo.
# ------------------------------------------------------------------------------

getCloneLocation() {
    if [ $# -eq 1 ]; then
        CLONE_LOCATION=$PWD/$1
    elif [ $# -eq 2 ]; then
        CLONE_LOCATION_INPUT=$2
        echo $2/$PACKAGE_NAME
        return
    else
        echo "1) ~/Code/DoubleThreeDigital"
        echo "2) ~/Code/Statamic"
        read -r CLONE_LOCATION_INPUT

        if [ "$CLONE_LOCATION_INPUT" -eq 1 2>/dev/null ]; then
            CLONE_LOCATION=~/Code/DoubleThreeDigital/$PACKAGE_NAME
        elif [ "$CLONE_LOCATION_INPUT" -eq 2 2>/dev/null ]; then
            CLONE_LOCATION=~/Code/Statamic/$PACKAGE_NAME
        else
            echo "Invalid option"
            return
        fi
    fi

    echo "$CLONE_LOCATION"
}

# ------------------------------------------------------------------------------
# Fork, clone and install dependencies
# ------------------------------------------------------------------------------

oss() {
    GH_REPO=$1
    PACAKGE_VENDOR=`echo $1 | cut -d"/" -f1`
    PACKAGE_NAME=`echo $1 | cut -d"/" -f2`

    # Prompt the user for the clone location if not provided as an argument
    if [ $# -lt 2 ]; then
        echo "Which directory in ~/Code should this be cloned into? (Enter 1 or 2)"
        getCloneLocation
    else
        CLONE_LOCATION=$2
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


# ------------------------------------------------------------------------------
# Link up a package to the current project
# ------------------------------------------------------------------------------

osslink() {
    GH_REPO=$1
    PACAKGE_VENDOR=`echo $1 | cut -d"/" -f1`
    PACKAGE_NAME=`echo $1 | cut -d"/" -f2`

    # Prompt the user for the clone location if not provided as an argument
    if [ $# -lt 2 ]; then
        echo "In which ~/Code directory is this repository located? (Enter 1 or 2)"
        getCloneLocation
    else
        CLONE_LOCATION=$2
    fi

    # vendor symlink
    rm -rf vendor/$PACAKGE_VENDOR/$PACKAGE_NAME
    ln -s $CLONE_LOCATION vendor/$PACAKGE_VENDOR/$PACKAGE_NAME
    la vendor/$PACAKGE_VENDOR

    # public/vendor symlink
    if [[ -d "$CLONE_LOCATION/resources/dist" ]]
    then
        if [[ $PACAKGE_VENDOR == "statamic" && $PACKAGE_NAME == "cms" ]]
        then
            rm -rf public/vendor/statamic

            mkdir public/vendor
            mkdir public/vendor/statamic

            ln -s $CLONE_LOCATION/resources/dist public/vendor/statamic/cp
            la public/vendor/statamic/cp

            ln -s $CLONE_LOCATION/resources/dist/frontend public/vendor/statamic/frontend
            la public/vendor/statamic/frontend
        fi
    else
        if [[ -d "$CLONE_LOCATION/dist/build" ]]
        then
            rm -rf public/vendor/$PACKAGE_NAME
            ln -s $CLONE_LOCATION/dist public/vendor/$PACKAGE_NAME
            la public/vendor/$PACKAGE_NAME
        fi
    fi
}
