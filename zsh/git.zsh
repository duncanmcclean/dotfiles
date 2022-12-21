alias all="git add ."
alias push="git push"
alias pull="git pull"
alias commit="git commit -m"
alias wip="all && commit 'wip'"
alias reset="git reset"
alias clone="git clone"
alias init="git init && git add . && git commit -m 'Initial commit'"
alias status="git status"
alias nah="git reset HEAD --hard"
alias diff="git diff"
alias unstage="git reset"


# ------------------------------------------------------------------------------
# Borrowed from Jesse Leite's dotfiles (https://github.com/jesseleite/dotfiles/blob/master/zsh/local/git.zsh)
# ------------------------------------------------------------------------------

# Git checkout with fzf fuzzy search
check() {
  if [ -n "$1" ]; then git checkout $1; return; fi
  git branch -vv | fzf | awk '{print $1}' | xargs git checkout
}

# Git checkout remote branch with fzf fuzzy search
checkr() {
  git fetch
  if [ -n "$1" ]; then git checkout $1; return; fi
  git branch --all | fzf | sed "s#remotes/[^/]*/##" | xargs git checkout
}

# Git checkout a PR with fzf fuzzy search
checkpr() {
  if [ -n "$1" ]; then gh pr checkout $1; return; fi
  gh pr list | fzf | awk '{print $1}' | xargs gh pr checkout
}

# Git checkout tag with fzf fuzzy search
checkt() {
  if [ -n "$1" ]; then git checkout $1; return; fi
  git tag | fzf | xargs git checkout
}

# Git delete branch with fzf fuzzy search
deletebranch() {
  if [ -n "$1" ]; then git branch -d $1; return; fi
  local selected=$(git branch -vv | fzf | awk '{print $1}' | sed "s/.* //")
  if [ -z "$selected" ]; then return; fi
  echo "Are you sure you would like to delete branch [\e[0;31m$selected\e[0m]? (Type 'delete' to confirm)"
  read confirmation
  if [[ "$confirmation" == "delete" ]]; then
    git branch -D $selected
  fi
}

# Undo last commit and tip of branch
# Optionally pass param to specify number of commits to undo (ie. `gundo 3`)
gundo() {
  if [ -n "$1" ]; then
    git reset HEAD~$1
  else
    git reset HEAD~1
  fi
  echo "\nRecent commits:"
  glog -n 5
}
