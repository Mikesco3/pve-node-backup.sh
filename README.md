# pve-node-backup.sh

This is a script to backup proxmox ve nodes. <br>
*(Not necessarily the virtual machines, but the root filesystem of the proxmox VE node)*

**Syntax:** <br>
 ` $pve-node-backup.sh DESTINATION 1  [OPTION] `

**OPTION:**  <br>
The 3rd optional parameter is to tag backups, e.g. in case we schedule the job via cron, <br>
it can tag and rename the backups and lists (e.g., manual, daily, weekly, monthly, etc) <br>
So subsequent cleanups happen within a certain tagged backup group. <br>
In other words, so that when running a weekly backup we don't delete the daily or manual backups.

**Example:** <br>
 $pve-node-backup.sh /Backup/Path 3  weekly
 
 in the example we are: <br>
 - backing up the root folder of proxmox,
 - to the destination: /Backup/Path 
 - keeping 3 backups (deleting anything prior)
 - naming it our weekly backup. (This is optional)


**Cron example:** <br>
weekly every sunday at 1:15 to /Backup/Path <br>
> 15 1 * * SUN /usr/sbin/pve-node-backup.sh /Backup/Path 3  weekly
