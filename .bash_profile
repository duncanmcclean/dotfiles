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
alias cdvm="cd /Users/Duncan/VMs/Homestead"
alias hosts="sudo nano /etc/hosts"
alias vmsites="cdvm && nano homestead.yaml"
alias addsite="hosts && vmsites && reprov"
alias start="cdvm && vagrant resume"
alias end="cdvm && vagrant suspend"
alias talk="cdvm && vagrant ssh"
alias reprov="cdvm && vagrant reload --provision"
alias homestead="cd /Users/Duncan/Homestead"

# Finder - Hide/Show
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Git
alias all="git add ."
alias push="git push"
alias pull="git pull"
alias commit="git commit -m"
alias check="git checkout"
alias branch="git branch"
alias reset="git reset"

# Laravel
alias art="php artisan"
alias migrate="art migrate"
alias fresh="art migrate --fresh"

# Valet
alias share="valet share"
alias sites="cd /Users/Duncan/Sites"

# Laravel Mix
alias dev="npm run dev"
alias watch="npm run watch"
alias prod="npm run production"
alias deploy="npm run deploy"

# Other
alias study="cd /Users/Duncan/Vue/RevisionNotes && subl . && npm run docs:dev"
alias profile="source ~/.bash_profile"
alias clearmail=": > /var/mail/$USER"
alias cls="clear"
alias middle="bundle exec middleman server"
alias serve="jekyll serve"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy"
alias static="git clone https://github.com/damcclean/boilerplate-static.git static && cd static && rm -rf .git && git init && npm install && npm run dev && cd .."
alias iprod="cd /Users/Duncan/Sites/iamlittle/scripts && sh ./production-sync.sh"
alias phpunit="vendor/bin/phpunit"

# G Cloud

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/duncan/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/duncan/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/duncan/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/duncan/google-cloud-sdk/completion.zsh.inc'; fi