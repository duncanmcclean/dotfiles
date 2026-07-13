#!/usr/bin/env bash

set -euo pipefail

VOLUME_PATH="/Volumes/LaCie"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_PATH="${VOLUME_PATH}/${TIMESTAMP}"

localPaths=(
    "$HOME/.config/filezilla"
    "$HOME/.config/raycast"
    "$HOME/.ssh/config"
    "$HOME/.vscode"
    "$HOME/Code"
    "$HOME/Library/Application Support/Code"
    "$HOME/Library/Application Support/JetBrains"
)

gum log --structured --level info "Backing up to $BACKUP_PATH"

mkdir -p "$BACKUP_PATH"
touch "$BACKUP_PATH/.incomplete"

for localPath in "${localPaths[@]}"; do
    destination="$BACKUP_PATH/${localPath#$HOME/}"
    mkdir -p "$(dirname "$destination")"

    if [[ -d "$localPath" ]]; then
        gum log --structured --level info "Backing up ${localPath#$HOME/}"

        caffeinate -i rsync -ah \
            --info=progress2 \
            --exclude='*.sock' \
            --exclude='node_modules/' \
            --exclude='vendor/' \
            "$localPath/" "$destination/"
    else
        rsync -ah \
            --info=progress2 \
            "$localPath" "$destination"
    fi
done

if rclone listremotes | grep -q '^dropbox:$'; then
    gum log --structured --level info "Backing up Dropbox..."

    caffeinate -i rclone sync \
        dropbox: \
        "$BACKUP_PATH/Dropbox" \
        --progress \
        --transfers=8 \
        --checkers=16 \
        --metadata
else
    gum log --structured --level error "Unable to backup to Dropbox. Please run 'rclone config' to add a remote."
fi

rm "$BACKUP_PATH/.incomplete"
gum log --structured --level info "Backup complete!" timestamp "$TIMESTAMP"
