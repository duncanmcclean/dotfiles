# Dumps MySQL databases for every site on this server, if one is set and uploads the .sql files to Amazon S3

# Create temp directory
rm -rf $HOME/.backups
mkdir $HOME/.backups

# Loop through Forge sites on this server
for siteDirectory in $HOME/sites/*/ ; do
    siteName=$(basename $siteDirectory)

    echo "$siteDirectory"
    cd $siteDirectory

    if [ -f .env ]; then
        DB_HOST=$(cut -d "=" -f2 <<< $(grep DB_HOST .env | xargs))
        DB_PORT=$(cut -d "=" -f2 <<< $(grep DB_PORT .env | xargs))
        DB_DATABASE=$(cut -d "=" -f2 <<< $(grep DB_DATABASE .env | xargs))
        DB_USERNAME=$(cut -d "=" -f2 <<< $(grep DB_USERNAME .env | xargs))
        DB_PASSWORD=$(cut -d "=" -f2 <<< $(grep DB_PASSWORD .env | xargs))

        DB_EXISTS=$(mysqlshow --user=$DB_USERNAME --password=$DB_PASSWORD $DB_DATABASE| grep -v Wildcard | grep -o $DB_DATABASE 2>/dev/null)

        if [ "$DB_EXISTS" == $DB_DATABASE ]; then
            mysqldump -u $DB_USERNAME --password=$DB_PASSWORD --port=$DB_PORT $DB_DATABASE > $HOME/.backups/$siteName.sql
        fi
    fi
done

# Zip up database backups
BACKUP_ARCHIVE=$(date '+%Y-%m-%d_%H:%M:%S')
tar -czvf $BACKUP_ARCHIVE.tar.gz $HOME/.backups/*.sql

# TODO: upload to Amazon S3

# Delete temp directory
# rm -rf $HOME/.backups
