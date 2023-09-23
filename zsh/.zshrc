export DOTFILES="$HOME/.dotfiles"
export ZSH="$HOME/.oh-my-zsh"

# ------------------------------------------------------------------------------
# Zsh Config
# ------------------------------------------------------------------------------

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
HIST_STAMPS="dd/mm/yyyy"
ZSH_DISABLE_COMPFIX="true"
ZSH_CUSTOM=$DOTFILES/zsh
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh


# ------------------------------------------------------------------------------
# Paths
# ------------------------------------------------------------------------------

export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH=$PATH:/usr/local/mysql/bin/
export PATH=/usr/local/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


# ------------------------------------------------------------------------------
# Node Version Manager (NVM)
# ------------------------------------------------------------------------------

export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
