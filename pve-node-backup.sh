#!/bin/sh

## Variables
BACKUP_STORAGE_PATH=${1%/}
NUM_OF_RETAINED_BACKUPS=$2
BACKUP_FILE_NAME=PVE-Backup-`hostname`-$3
BACKUP_FILE_LIST=$BACKUP_FILE_NAME"_list.txt"
RM_BACKUP_LIST=$BACKUP_FILE_NAME"_rm_list.txt"

## To Manually override path and set and uncomment the following variables:
# BACKUP_STORAGE_PATH=/mnt/Backup
# NUM_OF_RETAINED_BACKUPS=6
# BACKUP_FILE_NAME=PVE-Backup-`hostname`-weekly

ERROR0="No Arguments passed"
ERROR1="pease enter a backup path, then a number"
ERROR2="Enter a number of backups to keep"

## print variables
echo $BACKUP_STORAGE_PATH
echo $NUM_OF_RETAINED_BACKUPS
echo $BACKUP_FILE_NAME
echo $BACKUP_FILE_LIST
echo $RM_BACKUP_LIST

## check variables

## first if no arguments passed
if [ "$#" -eq 0 ]
then
    echo "
	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
	
	for questions or feedback check out: 
	https://github.com/Mikesco3/pve-node-backup.sh
	"
	echo '\n'
	
    echo "ERROR0" $ERROR0 ;
	echo "  add: 
	    1st argument: /path/to/backup, 
		2nd argument: #(of backups to keep), 
		3rd argument: (optional): backup type (manual, daily, weekly, monthly, etc)" ;
    echo "  for Example: ";
	echo "              pve-node-backup.sh /mnt/ExtHD 3 weekly";
		
	exit 1
fi

echo '\n'

## test if in the first argument is not empty or 
## if there is a number instead of a path
case $1 in
    ''|[0-9]*) echo "ERROR1" $ERROR1 ;;
    *) echo "backup path:" $1 ;;
esac

## check if second argument is NOT empty and if it is a number 
case $2 in
    ''|*[!0-9]*) echo "ERROR2" $ERROR2 ;;
    *) echo "backups to keep:" $2 ;;
esac

echo '\n' 

echo " Arguments passed:" ;
echo $1 $2 ;

echo $BACKUP_FILE_NAME


if [ -d "$BACKUP_STORAGE_PATH" ]; then
  ### Take action if $BACKUP_STORAGE_PATH exists ###
  echo "Backing up Proxmox to ${BACKUP_STORAGE_PATH}..."
  cd /
  pwd
  
  echo tar "$BACKUP_STORAGE_PATH/$BACKUP_FILE_NAME""_root_""`date +"%Y-%m-%d-%H%M"`".tgz .

  tar \
   --exclude='./dev' \
   --exclude='./sys' \
   --exclude='./proc' \
   --exclude='./mnt' \
   --exclude='./tmp' \
   --exclude='./run' \
   --exclude='./var/log' \
   --exclude='./var/spool' \
   --exclude='./var/lib/samba/private' \
   --exclude='./var/lib/lxcfs' \
   --exclude='./lost+found' \
   --exclude='./tank100' \
   --exclude='./_Backup' \
   -zcvf "$BACKUP_STORAGE_PATH/$BACKUP_FILE_NAME""_root_""`date +"%Y-%m-%d-%H%M"`".tgz .
   
   cd $BACKUP_STORAGE_PATH
   pwd 
   
   ls -1 |grep tgz |grep -i $BACKUP_FILE_NAME > $BACKUP_FILE_LIST
   
   cat $BACKUP_FILE_LIST

   # read -t 5 -p "waiting for 5 seconds only... then move to deleting old backups "
   
   echo "About to delete backups older than $NUM_OF_RETAINED_BACKUPS backups"

   # read -t 5 -p "waiting for 5 seconds only... CTRL +C to cancel"

   cp $BACKUP_FILE_LIST "`echo $BACKUP_FILE_LIST`"_bak
   
    tac $BACKUP_FILE_LIST  | \
	awk "{ if ( NR > $NUM_OF_RETAINED_BACKUPS ) print; }" | \
	tac > $RM_BACKUP_LIST
	cat  $RM_BACKUP_LIST
	   
	   if [ -f "$BACKUP_STORAGE_PATH/$RM_BACKUP_LIST" ]; then
		   echo "$BACKUP_STORAGE_PATH/$RM_BACKUP_LIST exists."
		   # read -t 5 -p "waiting for 5 seconds only... CTRL +C to cancel"
		   
		   # rm -f $(<`echo $RM_BACKUP_LIST`)
		   for f in $( cat $RM_BACKUP_LIST ) ; do 
		   rm "$f"
		   done
		  mv $RM_BACKUP_LIST "`echo $RM_BACKUP_LIST`"_bak

	else 
		echo "$BACKUP_STORAGE_PATH/$RM_BACKUP_LIST does not exist."
	fi

	else
  ###  Control will jump here if $BACKUP_STORAGE_PATH does NOT exists ###
  echo "Error: ${BACKUP_STORAGE_PATH} not found. Can not continue."
  exit 1
fi

## GPLv3 
    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with this program.  If not, see <https://www.gnu.org/licenses/>.

## 20210824: Added gpl, made it ready for proxmox VE 7 and published on github 
