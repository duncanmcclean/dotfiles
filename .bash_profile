export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH=$PATH:/usr/local/mysql/bin/
export PATH=/usr/local/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# BiblioSpot
alias backupbs="ssh codepier@206.189.24.237 'cd bibliospot.com/current/scripts && sh backup.sh && exit'"

# Statamic
alias please="php please"
alias pls="php please"

# Finder - Hide/Show
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Git
alias add="git add"
alias all="git add ."
alias push="git push"
alias pull="git pull"
alias commit="git commit -m"
alias check="git checkout"
alias branch="git branch"
alias reset="git reset"
alias clone="git clone"

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
alias mixupdate="npm remove laravel-mix && npm install laravel-mix && npm run dev"

# Webpack
alias serve="npm run serve"

# Other
alias study="cd /Users/Duncan/Vue/RevisionNotes && subl . && npm run docs:dev"
alias profile="source ~/.bash_profile"
alias clearmail=": > /var/mail/$USER"
alias cls="clear"
alias middle="bundle exec middleman server"
alias jserve="jekyll serve"
alias key="cat ~/.ssh/id_rsa.pub | pbcopy"
alias static="git clone https://github.com/damcclean/boilerplate-static.git static && cd static && rm -rf .git && git init && npm install && npm run dev && cd .."
alias iprod="cd /Users/Duncan/Sites/iamlittle/scripts && sh ./production-sync.sh"
alias phpunit="vendor/bin/phpunit"

# G Cloud

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/duncan/gcloud/path.zsh.inc' ]; then . '/Users/duncan/gcloud/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/duncan/gcloud/completion.zsh.inc' ]; then . '/Users/duncan/gcloud/completion.zsh.inc'; fi