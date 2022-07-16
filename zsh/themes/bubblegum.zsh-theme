PROMPT='%{$fg_bold[magenta]%}▲ $(get_pwd) %{$reset_color%}'

function get_pwd() {
  echo "${PWD/$HOME/~}"
}
