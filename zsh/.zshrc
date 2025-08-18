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
export PATH=/Users/duncan/.opencode/bin:$PATH

# Herd injected PHP binary.
export PATH="/Users/duncan/Library/Application Support/Herd/bin/":$PATH

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/duncan/Library/Application Support/Herd/config/php/83/"

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/duncan/Library/Application Support/Herd/config/php/84/"


# ------------------------------------------------------------------------------
# Node Version Manager (NVM)
# ------------------------------------------------------------------------------

# Herd injected NVM configuration
export NVM_DIR="/Users/duncan/Library/Application Support/Herd/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"


# ------------------------------------------------------------------------------
# Starship
# https://github.com/starship/starship
# ------------------------------------------------------------------------------

eval "$(starship init zsh)"


# ------------------------------------------------------------------------------
# Zoxide (smarter cd command)
# https://github.com/ajeetdsouza/zoxide
# ------------------------------------------------------------------------------

eval "$(zoxide init zsh)"