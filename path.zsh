export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH=$PATH:/usr/local/mysql/bin/
export PATH=/usr/local/bin:$PATH
export PATH="$PATH:`pwd`/flutter/bin"

# For Android Development
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"