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

mysqlDumpsPath="$BACKUP_PATH/Databases/MySQL"
postgresDumpsPath="$BACKUP_PATH/Databases/PostgreSQL"
postgresBinPath="$(dirname "$(readlink -f "$(command -v psql)")")"

if mysql -uroot -h127.0.0.1 -e 'select 1' > /dev/null 2>&1; then
    gum log --structured --level info "Backing up MySQL databases..."
    mkdir -p "$mysqlDumpsPath"

    mysql -uroot -h127.0.0.1 -N -e 'show databases' \
        | grep -Ev '^(information_schema|performance_schema|mysql|sys)$' \
        | while read -r database; do
            gum log --structured --level info "Dumping $database"

            if ! caffeinate -i mysqldump -uroot -h127.0.0.1 --single-transaction --routines --triggers --events "$database" | gzip > "$mysqlDumpsPath/$database.sql.gz"; then
                gum log --structured --level error "Failed to dump MySQL database" database "$database"
            fi
        done
else
    gum log --structured --level error "Unable to backup MySQL databases. Is the MySQL service running in Herd?"
fi

if [[ -x "$postgresBinPath/pg_dump" ]] && psql -U root -h 127.0.0.1 -d postgres -c 'select 1' > /dev/null 2>&1; then
    gum log --structured --level info "Backing up PostgreSQL databases..."
    mkdir -p "$postgresDumpsPath"

    psql -U root -h 127.0.0.1 -d postgres -Atc "select datname from pg_database where not datistemplate and datname <> 'postgres'" \
        | while read -r database; do
            gum log --structured --level info "Dumping $database"

            if ! caffeinate -i "$postgresBinPath/pg_dump" -U root -h 127.0.0.1 --format=custom --file "$postgresDumpsPath/$database.dump" "$database"; then
                gum log --structured --level error "Failed to dump PostgreSQL database" database "$database"
            fi
        done
else
    gum log --structured --level error "Unable to backup PostgreSQL databases. Is the PostgreSQL service running in Herd?"
fi

rm "$BACKUP_PATH/.incomplete"
gum log --structured --level info "Backup complete!" timestamp "$TIMESTAMP"
