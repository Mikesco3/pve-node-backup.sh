# pve-node-backup.sh

This is a script to backup proxmox ve nodes.

syntax: 
 $pve-node-backup.sh /BackupPath 3  weekly
 
 (in the example we are:
 - backing up the root folder of proxmox,
 - keeping 3 backups
 - naming it our weekly backup.

So that if we schedule the job via cron, it can be scheduled to run weekly, daily, monthly, etch
For example weekly every sunday at 1:15 to /BackupPath
15 1 * * SUN /usr/sbin/pve-node-backup.sh /BackupPath 3  weekly
