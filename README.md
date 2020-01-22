# Tarnation
A simple, extensible tar backup/restore utility

##### Current Version: v1.2.0

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

`-r      [ ] puts the script in restore mode`

`-v      [ ] sets the logging to verbose`

_\* -v will be operational in future versions_

### General Usage
Tarnation will make a single tar backup of the directory specified. It does not recursively back up individual sub directories. It simply makes a snapshot backup of the directory specified. To put it in perspective, you should not backup `/home/` if you have several directories inside `/home/` that you want to back up with tar versions. Instead it's recommended that you use tarnation on the specific directories you need to back up. For example, I store all my docker configurations inside of `/root/docker/`. The directory looks like this:
```bash
/root/docker/
├── filebrowser/
├── jackett/
├── lidarr/
├── nextdb/
├── ombi/
├── plexv2/
├── portainer/
├── radarr/
├── sonarr/
├── syncarr/
└── tautulli/
```
Best practice would be to backup all the directories inside of `/root/docker/` instead of only backing up `/root/docker/`. **Future versions will accept a directory and a flag that will recursively handle all sub-directories as if they were individually backed up.**

### Example Environment
- Script Location: `/opt/scripts/backup/tarnation.sh`
- Backup Destination: `/opt/backup/`
- SNAR Config Root Directory: `/opt/scripts/backup/config/`
- Example:
`tarnation.sh -d /root/test/backupfolder -b /opt/backup/ -c /opt/scripts/backup/config/`

\* this example environment is best executed with a cron job for automated backups. *

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
Restoring the backup is extremely easy. The command syntax for the restore script is exactly the same as the backup script with an additional `-r` flag. Note, during a restore, the config snar is not used, so you can pass any variable as the `-c` flag. It just can't be missing or empty.

Example:
- Backup via

```tarnation.sh -d /root/test -b /backup/ -c /opt/scripts/backup/config/ -l /opt/scripts/backup/tarnation.log```
- Restore via

```tarnation-restore.sh -r -d /root/test -b /backup/ -c /opt/scripts/backup/config/ -l /opt/scripts/backup/tarnation.log```

The restore process is simplistic (and as of v1.2, quite rudimentary). It basically grabs all the tar files and unpacks them in order. This means that it will cycle through all full and incremental backups in order during the restore. Future versions will allow you skip old full backups and only restore the most recent full backup and the subsequent incremental backups, therefore drastically improving performance. Also, as of v1.1.0, the target restore directory needs to be deleted. In future versions, the target directory (if existing) will be backed up for a restore point and then deleted in preparation for the restore.

### Roadmap Features
- `-r` flag on the tarnation.sh script for restoring (instead of having to use a separate restore script)
- `-v` flag to enable more verbose logging
- Recursive backup of sub-directories, as defined by a level integer
- Backup retention policies
- gpg optional encryption
- Automatic removal of the target directory being restored
- Better handling of the restore files
- CLI GUI to select the restore point in time (currently, it will restore all tar files up the last backup)
