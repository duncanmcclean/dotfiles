export DOTFILES="$HOME/.dotfiles"
export ZSH="$HOME/.oh-my-zsh"


# ------------------------------------------------------------------------------
# Zsh Config
# ------------------------------------------------------------------------------

ZSH_THEME="spaceship"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
HIST_STAMPS="dd/mm/yyyy"
ZSH_DISABLE_COMPFIX="true"
ZSH_CUSTOM=$DOTFILES/zsh
plugins=(git)

source $ZSH/oh-my-zsh.sh


# ------------------------------------------------------------------------------
# Paths
# ------------------------------------------------------------------------------

export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH=$PATH:/usr/local/mysql/bin/
export PATH=/usr/local/bin:$PATH
export PATH="$PATH:$HOME/mys"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


# ------------------------------------------------------------------------------
# Node Version Manager (NVM)
# ------------------------------------------------------------------------------

#if [[ hostname == "Steadfast-Mac-3.local" ]]; then
    export NVM_DIR="$HOME/.nvm"
        [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
        [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
#fi
