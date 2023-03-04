alias cl="clear"
alias profile="source ~/.zshrc"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy"
alias cleardns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias hosts="sudo nano /etc/hosts"
alias redflush="redis-cli flushall"


# ------------------------------------------------------------------------------
# Finder
# ------------------------------------------------------------------------------

alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"


# ------------------------------------------------------------------------------
# Shortcuts
# ------------------------------------------------------------------------------

alias home="cd ~"
alias sites="cd ~/Sites"
alias proj="cd ~/Projects"
alias dots="cd ~/.dotfiles"


# ------------------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------------------

export HOMEBREW_NO_AUTO_UPDATE=1
