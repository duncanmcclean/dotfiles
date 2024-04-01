alias cl="clear"
alias profile="source ~/.zshrc"
alias hosts="sudo vim /etc/hosts"
alias sshconfig="sudo vim ~/.ssh/config"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy"
alias cleardns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias hammertime="killall Hammerspoon && open /Applications/Hammerspoon.app"


# ------------------------------------------------------------------------------
# Internet Connection
# Thanks to @jasonvarga for this snippet!
# ------------------------------------------------------------------------------

internet() {
    disconnected=false

    while ! ping 8.8.8.8 -c 1 &> /dev/null; do
        echo '❌ No internet connection.'
        disconnected=true
        sleep 1;
    done;

    # Show notification only if it was ever disconnected, so you
    # can leave the command running in the background.
    if $disconnected; then
        osascript -e 'display notification "Connection restored ✅" with title "Internet"'
    fi

    echo '✅ Connected to internet.'
}


# ------------------------------------------------------------------------------
# Finder
# ------------------------------------------------------------------------------

alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"


# ------------------------------------------------------------------------------
# Shortcuts
# ------------------------------------------------------------------------------

alias home="cd ~"
alias dots="cd ~/.dotfiles"


# ------------------------------------------------------------------------------
# EaZy Project Access
# ------------------------------------------------------------------------------

z() {
    # When project is provided as an argument, go to that project.
    if [ -n "$1" ]; then
        if [ -d ~/Code/DoubleThreeDigital/$1 ]; then
            cd ~/Code/DoubleThreeDigital/$1
            return
        elif [ -d ~/Code/Statamic/$1 ]; then
            cd ~/Code/Statamic/$1
            return
        fi

        echo "Project not found."
        return
    fi

    doubleThreeProjects=($(basename -a $(ls -d ~/Code/DoubleThreeDigital/*/)))
    statamicProjects=($(basename -a $(ls -d ~/Code/Statamic/*/)))
    directories=("${doubleThreeProjects[@]}" "${statamicProjects[@]}")

    selected_dir=$(for dir in "${directories[@]}"; do echo $dir; done | fzf)
    cd $(find ~/Code/DoubleThreeDigital/ ~/Code/Statamic/ -type d -name "$selected_dir" -print -quit)
}


# ------------------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------------------

export HOMEBREW_NO_AUTO_UPDATE=1
