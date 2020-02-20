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

`-d      [*] the directory candidate being backed up`

`-b      [*] the backup destination root directory`

`-c      [*] the config/snar definition root directory`

`-l      [ ] the log file to be used`

`-r      [ ] puts the script in restore mode`

`-s      [*] *integer* how many levels deep to consider a directory a tar candidate`

`-v      [ ] sets the logging to verbose`

_\* -v will be operational in future versions_

### General Usage
Tarnation will make a single tar backup of the directory specified. Although it does include subdirectories and folders, it simply makes a snapshot backup of the entire directory specified. To put it in perspective, you should not backup `/home/` if you have several directories inside `/home/` that you want to back up with tar versions. Instead it's recommended that you use tarnation on the specific directories you need to back up or to use the `-s int` flag introduced in v1.3. The integer is how many levels deep do you want to go to consider a directory a tar candidate. This means tarnation will recursively handle all sub-directories as if they were individually backed up. Currently only -`s 0` and `1` are supported. `0` means tarnation will not try to individually tar subdirectories and it will just tar the main directory (which also includes subdirs).

### Example Environment
- Script Location: `/opt/scripts/backup/tarnation.sh`
- Backup Destination: `/opt/backup/`
- SNAR Config Root Directory: `/opt/scripts/backup/config/`
- Example:
`tarnation.sh -d /root/test/backupfolder -s 0 -b /opt/backup/ -c /opt/scripts/backup/config/`

\* this example environment is best executed with a cron job for automated backups. *

### Navigating the Backups

Viewing the backup tar.gz files is very easy. Simple navigate to your specified backup destination. The backup destination root folder will then resemble the root of your actual drive. For the example environment, the backup destination looks like so:
```bash
/opt/backup/
└── root
    └── test
        └── backupfolder.2020.01.09.15.04.41.tar.gz
```
where the original directory looks like this:
```bash
/root/test/
└── backupfolder
    ├── somefile.xlsx
    ├── a.pdf
    ├── another.xlsm
    ├── second.pdf
    └── subdir1/
        ├── file1
        ├── my.xlsm
        └── file2
    └── subdir2/
        ├── file3
        ├── some.xlsm
        └── file4
```

Using `-s 1` would result in the following tar backups:

```bash
/opt/backup/
└── root
    └── test
        └── backupfolder
            ├── subdir1.2020.01.09.15.04.41.tar.gz
            └── subdir2.2020.01.09.15.04.42.tar.gz
```

The latter command is ideal for backing up multiple directories independently, where they all need their own versioning. Personally, I back up several of my application config folders, which are all found in `/root/docker/`. Using the `-s 1` command allows flexibility to back up all app config folders in `/root/docker/`.

### Restoring the backup
Restoring the backup is extremely easy. The command syntax for the restore script is exactly the same as the backup script with an additional `-r` flag. Note, during a restore, the config snar is not used, so you can pass any variable as the `-c` flag. It just can't be missing or empty.

Example:
- Backup via

```tarnation.sh -d /root/test -b /backup/ -c /opt/scripts/backup/config/ -l /opt/scripts/backup/tarnation.log```
- Restore via

```tarnation.sh -r -d /root/test -b /backup/ -c /opt/scripts/backup/config/ -l /opt/scripts/backup/tarnation.log```

The restore process is simplistic (and as of v1.2, quite rudimentary). It basically grabs all the tar files and unpacks them in order. This means that it will cycle through all full and incremental backups in order during the restore. Future versions will allow you skip old full backups and only restore the most recent full backup and the subsequent incremental backups, therefore drastically improving performance. Also, as of v1.1.0, the target restore directory needs to be deleted. In future versions, the target directory (if existing) will be backed up for a restore point and then deleted in preparation for the restore.

### Roadmap Features
- `-v` flag to enable more verbose logging
- Recursive backup of sub-directories, as defined by a level integer
- Backup retention policies
- gpg optional encryption
- Automatic removal of the target directory being restored
- Better handling of the restore files
- CLI GUI to select the restore point in time (currently, it will restore all tar files up the last backup)