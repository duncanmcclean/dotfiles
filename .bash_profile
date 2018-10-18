export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH=$PATH:/usr/local/mysql/bin/
export PATH=/usr/local/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# BiblioSpot
alias merge="sh /Users/Duncan/Scripts/MergeIntoMaster.sh"
alias backupbs="sh /Users/Duncan/Scripts/BackupBiblioSpot.sh"

# Statamic
alias update="sh /Users/Duncan/Scripts/UpdateStatamicSites.sh"
alias please="php please"

# Homestead
alias hosts="sudo nano /etc/hosts"
alias start="cd /Users/Duncan/VMS/Homestead && vagrant resume"
alias end="cd /Users/Duncan/VMS/Homestead && vagrant suspend"
alias talk="cd /Users/Duncan/VMs/Homestead && vagrant ssh"

# Finder - Hide/Show
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Git
alias all="git add ."
alias push="git push"
alias pull="git pull"
alias commit="git commit -m"

# Laravel
alias art="php artisan"

# Valet
alias share="valet share"

# Laravel Mix
alias dev="npm run dev"
alias watch="npm run watch"
alias prod="npm run production"
alias deploy="npm run deploy"

# Other
alias study="cd /Users/Duncan/Vue/RevisionNotes && subl . && npm run docs:dev"
alias profile="source ~/.bash_profile"
alias clearmail=": > /var/mail/$USER"