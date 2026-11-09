#!/usr/bin/env bash

set -euo pipefail

SOURCE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
CHECKOUTS_PATH="$HOME/.local/share/amp-user-skills"

accounts=(
    "duncan@doublethree.digital"
    "duncan@statamic.com"
)

excludedSkills() {
    case "$1" in
        duncan@statamic.com) echo "review" ;;
    esac
}

activeAccount=$(amp account list | awk '$1 == "*" { print $2 }')
trap 'amp account switch "$activeAccount" > /dev/null' EXIT

for account in "${accounts[@]}"; do
    checkoutPath="$CHECKOUTS_PATH/$account"

    amp account switch "$account" > /dev/null

    repositories=$(amp skills repositories)

    if [[ -d "$checkoutPath/.git" ]]; then
        gum log --structured --level info "Pulling personal skills repository" account "$account"
        git -C "$checkoutPath" pull --ff-only --quiet
    elif grep -q '^User Skills (exists' <<< "$repositories"; then
        gum log --structured --level info "Cloning personal skills repository" account "$account"
        amp clone user-skills "$checkoutPath" > /dev/null
    else
        gum log --structured --level info "Creating personal skills repository" account "$account"
        git init --quiet --initial-branch main "$checkoutPath"
        git -C "$checkoutPath" remote add origin "$(awk '/^User Skills/ { getline; print $1 }' <<< "$repositories")"
    fi

    rsync -a --delete --exclude .git "$SOURCE_PATH/" "$checkoutPath/"

    for skill in $(excludedSkills "$account"); do
        rm -rf "$checkoutPath/$skill"
    done

    if [[ -z "$(git -C "$checkoutPath" status --porcelain)" ]]; then
        gum log --structured --level info "Skills are already up to date" account "$account"
        continue
    fi

    git -C "$checkoutPath" add --all
    git -C "$checkoutPath" commit --quiet --message "sync skills from dotfiles"
    git -C "$checkoutPath" push --quiet --set-upstream origin main

    gum log --structured --level info "Pushed skills" account "$account"
done

gum log --structured --level info "Done!"
