# Tarnation
A simple, extensible tar backup/restore utility

##### Current Version: v1.1.0

### Features
- Uses GNU tar for a simple, clear, compressed backup 
- Offers incremental backup using snar files
- Easy folder structure. No need to go digging in unfamiliar directory names
- Extremely simple restore process

### Installation
- Clone the repository
- Change directory into the cloned repo: `cd tarnation`
- Make the script executable: `chmod +x tarnation.sh`
- Run appropriate commands with the required flags (see command options)

### Command Options
`* indicates a required option`

`-d      [*] the directory being backed up`

`-b      [*] the backup destination root directory`

`-c      [*] the config/snar definition root directory`

`-l      [ ] the log file to be used`

`-v      [ ] sets the logging to verbose`

_\* -v will be operational in future versions_

### Example Environment
- Script Location: `/opt/scripts/backup/tarnation.sh`
- Backup Destination: `/opt/backup/`
- SNAR Config Root Directory: `/opt/scripts/backup/config/`
- Example:
`tarnation.sh -d /root/test/backupfolder -b /opt/backup/ -c /opt/scripts/backup/config/`

\** this example environment is best executed with a cron job for automated backups. *

### Navigating the Backups

Viewing the backup tar.gz files is very easy. Simple navigate to your specified backup destination. The backup destination root folder will then resemble the root of your actual drive. For the example environment, the backup destination looks like so:
```bash
/opt/backup/
└── root
    └── test
        └── backupfolder.2019.12.09.15.04.41.tar.gz
```
where the original directory looks like this:
```bash
/root/test/
└── backupfolder
    ├── somefile.xlsx
    ├── a.pdf
    ├── another.xlsm
    └── second.pdf
```

### Restoring the backup
Restoring the backup is extremely easy. The command syntax for the restore script is exactly the same as the backup script. Simply run the tarnation-backup.sh with the same parameters that were used to create the backup.

Example:
- Backup via 

```tarnation.sh -d /root/test -b /backup/ -c /opt/scripts/backup/config/ -l /opt/scripts/backup/tarnation.log```
- Restore via 

```tarnation-restore.sh -d /root/test -b /backup/ -c /opt/scripts/backup/config/ -l /opt/scripts/backup/tarnation.log```

As of v1.1.0, the target restore directory needs to be deleted. In future versions, the target directory (if existing) will be backed up for a restore point and then deleted in preparation for the restore. 
