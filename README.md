# Tarnation
A simple, extensible tar backup/restore utility

### Features
- Uses GNU tar for a simple, clear, compressed backup 
- Offers incremental backup using snar files
- Easy folder structure. No need to go digging in unfamiliar directory names

### Coming Soon
- related restore script for a simple but extremely powerful restore process

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

\* -l and -v will be operational in v1.1 

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

To restore the tar.gz, follow these steps (these are unique, but have a specific purpose) 
- Copy the tar file to the correct directory. In this case, copy it to `/root/test/` 
- cd into that directory: `cd /root/test/`
- Then "un-tar" it with `tar -xvf backupfolder.2019.12.09.15.04.41.tar.gz`

Due to the way v1.0 tars the directory, it does not preserve the full path when un-tared. Therefore, tar will unpack wherever the un-tar command is run. This is why it is important to cd into the parent directory before un-taring. The upcoming restore script will do this for you, of course. That is version 1.1, coming soon. 
