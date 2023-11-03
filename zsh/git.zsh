alias all="git add ."
alias pull="git pull"
alias wip="all && commit 'wip'"
alias reset="git reset"
alias clone="git clone"
alias init="git init && git add . && git commit -m 'Initial commit'"
alias status="git status"
alias nah="git reset HEAD --hard"
alias diff="git diff"
alias unstage="git reset"
alias empty="git commit --allow-empty -m 'Empty commit'"
alias merge="git merge"
alias ptag="git push --tags"
alias glt='git describe --tags --abbrev=0' # git latest tag
alias gcslt='git --no-pager log $(glt)..HEAD --oneline --no-decorate --first-parent --no-merges' # git commits since latest tag
alias changelog='gcslt && gcslt | pbcopy'

# Re-tag the latest release
function retag() {
    local latest_tag=$(git describe --tags --abbrev=0)
    git tag -d $latest_tag
    git push origin :refs/tags/$latest_tag
    git tag $latest_tag
    git push --tags
}

# Commit everything
function commit() {
    local description=""
    local coauthors=""
    local message=""

    # Function to display script usage
    function usage {
        echo "Usage: git_commit [-d <description>] [-c <coauthors>] <commit message>"
        echo "Options:"
        echo "  -d, --description <description>   Add a description to the Git commit"
        echo "  -c, --coauthors <coauthors>       Specify coauthors of the commit"
        exit 1
    }

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -d|--description)
                description="$2"
                shift
                shift
                ;;
            -c|--coauthors)
                coauthors="$2"
                shift
                shift
                ;;
            *)
                message="$1"
                shift
                ;;
        esac
    done

    # Check if a commit message is provided
    if [[ -z $message ]]; then
        echo "Commit message is missing."
        usage
    fi

    # Construct the commit command
    local commit_command="git commit -m \"$message\""

    # Add description if provided
    if [[ -n $description ]]; then
        commit_command+=" -m \"$description\""
    fi

    # Add coauthors if provided
    if [[ -n $coauthors ]]; then
        commit_command+=" -m \"Co-authored-by: $coauthors\""
    fi

    # Execute the commit command
    eval "$commit_command"
}

# Push commits to remote
function push() {
    branch=$(git rev-parse --abbrev-ref HEAD)

    if git ls-remote --exit-code --heads origin $branch >/dev/null 2>&1; then
        git push origin $branch
    else
        git push --set-upstream origin $branch
    fi
}

# ------------------------------------------------------------------------------
# Some of this was borrowed from Jesse Leite's dotfiles (https://github.com/jesseleite/dotfiles/blob/master/zsh/local/git.zsh)
# ------------------------------------------------------------------------------

# Git checkout with fzf fuzzy search
check() {
  if [ -n "$1" ]; then git checkout $1; return; fi
  git branch -vv | fzf | awk '{print $1}' | xargs git checkout
}

# Git checkout new branch
checknew() {
    if [ -n "$1" ]; then git checkout -b $1; return; fi
    local selected=$(git branch -vv | fzf | awk '{print $1}' | sed "s/.* //")
    if [ -z "$selected" ]; then return; fi
    git checkout -b $selected
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
rmbranch() {
  if [ -n "$1" ]; then git branch -d $1; return; fi
  local selected=$(git branch -vv | fzf | awk '{print $1}' | sed "s/.* //")
  if [ -z "$selected" ]; then return; fi
  echo "Are you sure you would like to delete branch [\e[0;31m$selected\e[0m]? (Type 'delete' to confirm)"
  read confirmation
  if [[ "$confirmation" == "delete" ]]; then
    git branch -D $selected
  fi
}

# Git delete tag with fuzzy search (on both local and remote)
rmtag() {
    if [ -n "$1" ]; then git tag -d $1; git push origin :refs/tags/$1; return; fi
    local selected=$(git tag | fzf)
    if [ -z "$selected" ]; then return; fi
    echo "Are you sure you would like to delete tag [\e[0;31m$selected\e[0m]? (Type 'delete' to confirm)"
    read confirmation
    if [[ "$confirmation" == "delete" ]]; then
        git tag -d $selected
        git push origin :refs/tags/$selected
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

# Merge another branch into current branch
gmerge() {
    git pull origin $1
    git push
}
