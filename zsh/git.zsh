alias all="git add ."
alias pull="git pull"
alias merge="git merge"
alias reset="git reset"
alias clone="git clone"
alias status="git status"
alias unstage="git reset"
alias commit="git commit -m"
alias wip="all && commit 'wip'"
alias nah="git reset HEAD --hard"
alias empty="git commit --allow-empty -m 'Empty commit'"
alias init="git init && git add . && git commit -m 'Initial commit'"
alias pushf="git push --force"
alias push="git push"


# ------------------------------------------------------------------------------
# Tagging & Releases
# ------------------------------------------------------------------------------

alias glt='git describe --tags --abbrev=0' # git latest tag
alias changelog="gcslt | sed -e 's/\[.*\] //g' | pbcopy" # git changelog
alias gcslt='git --no-pager log $(git describe --tags --abbrev=0)..HEAD --oneline --no-decorate --first-parent --no-merges' # git commits since latest tag

# Create a tag & push to the remote.
function gtag() {
    local tag=$1

    # Before tagging, ensure the tag follows the same format as the last tag.
    if [[ $(glt) == v* && $tag != v* ]]; then
        tag="v$tag"
    fi

    git tag $tag
    git push --tags
}

# Re-tag the latest tag.
function retag() {
    local latest_tag=$(git describe --tags --abbrev=0)
    git tag -d $latest_tag
    git push origin :refs/tags/$latest_tag
    git tag $latest_tag
    git push --tags
}


# ------------------------------------------------------------------------------
# Various other Git commands...
# Mostly borrowed from Jesse Leite's dotfiles (https://github.com/jesseleite/dotfiles/blob/master/zsh/local/git.zsh)
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
  local pr_number
  if [ -n "$1" ]; then
    pr_number=$1
  else
    pr_number=$(gh_pretty_list_prs | gum filter --placeholder 'Checkout PR...' | awk '{print $1}' | sed "s/#//")
    if [ -z "$pr_number" ]; then return; fi
  fi

  gh pr checkout $pr_number

  local pr_info=$(gh pr view $pr_number --json isCrossRepository,headRepositoryOwner,headRefName,headRepository)
  local is_fork=$(echo $pr_info | jq -r '.isCrossRepository')

  if [ "$is_fork" = "true" ]; then
    local fork_owner=$(echo $pr_info | jq -r '.headRepositoryOwner.login')
    local branch_name=$(echo $pr_info | jq -r '.headRefName')
    local repo_name=$(echo $pr_info | jq -r '.headRepository.name')
    local fork_url="git@github.com:${fork_owner}/${repo_name}.git"

    if git remote get-url $fork_owner &> /dev/null; then
      git remote set-url $fork_owner $fork_url
    else
      git remote add $fork_owner $fork_url
    fi
    git fetch $fork_owner

    git branch --set-upstream-to=$fork_owner/$branch_name
  fi
}

# Git delete branch with fzf fuzzy search
rmbranch() {
  if [ -n "$1" ]; then git branch -D $1; return; fi
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

# Back to the default branch
gmain() {
  git checkout $(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')
}

gh_pretty_list_prs() {
  gh pr list \
    --limit 500 \
    --json number,title,author,headRefName,updatedAt \
    --template '{{range .}}{{tablerow (printf "#%v" .number | autocolor "green") (truncate 60 .title) (truncate 15 .author.login) (truncate 40 .headRefName) (timeago .updatedAt)}}{{end}}'
}