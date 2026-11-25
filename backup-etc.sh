#!/usr/bin/bash
set -o pipefail

DEFAULT_SERVER="pve1"
REMOTE_SERVER="${1:-$DEFAULT_SERVER}"
CURRENT_DATE=$(date +"%Y-%m-%d")   # Get the current date in yyyy-mm-dd format
BACKUP_NAME="backup-${REMOTE_SERVER}_etc_${CURRENT_DATE}.tar.gz"   # Add date to the filename

# Backup remote /etc to local machine
if ssh "root@$REMOTE_SERVER" "tar -czf - -C /etc ." > "./$BACKUP_NAME"; then
    echo "Backup successful: ./$BACKUP_NAME"
else
    echo "Backup failed!"
    rm -f "./$BACKUP_NAME"  # Clean up empty/corrupt file on failure
    exit 1
fi
