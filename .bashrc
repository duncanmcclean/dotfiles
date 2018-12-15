
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

. ~/.bash_profile

###-tns-completion-start-###
if [ -f /Users/duncan/.tnsrc ]; then 
    source /Users/duncan/.tnsrc 
fi
###-tns-completion-end-###
