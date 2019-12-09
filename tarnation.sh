#!/bin/bash

# Author: Kenny Parsons
# Usage: Open Source
# Example: backup.sh -d /root/test/backupfolder -b /gvault/backup/ -c /opt/scripts/backup/config/

#Functions
backup(){
cd $PARENTDIR
tar -czg $SNAR -f $TAR $BASEDIR
}

dircheck(){
	if test -d $@; then
		return 0
	else 
		return 1
	fi
}

filecheck(){
	if test -e $@; then
		return 0
	else
		return 1
	fi
}

makedir(){
	mkdir -p $@
}

logger(){
	echo "logged"
}

print_usage(){
        echo " "
        echo " * indicates a required option"
        echo "-d	[*] the directory being backed up"
        echo "-b 	[*] the backup destination root directory"
        echo "-c 	[*] the config/snar definition root directory"
        echo "-l 	[ ] the log file to be used "
        echo "-v 	[ ] sets the logging to verbose"
}

#Process inputs
d_flag=''
b_flag=''
c_flag=''
l_flag=$PWD
verbose='false'

while getopts 'd:b:c:v' flag; do
        case "${flag}" in
                d) d_flag=${OPTARG} ;;
                b) b_flag=${OPTARG} ;;
                c) c_flag=${OPTARG} ;;
				l) logfile=${OPTARG} ;;
                v) verbose='true' ;;
                *) print_usage
                        exit 1 ;;
        esac
done

# Exit if required options are missing:
# Could use some tunning

if [ -z "$d_flag" ] || [ -z "$b_flag" ] || [ -z "$c_flag" ]; then
	print_usage
	exit 1
fi

###################################
# Provided Variables
#No trailing slash
DIRECTORY=${d_flag%/}
BACKUPTO=${b_flag%/}
CONFIG=${c_flag%/} #defaults to current directory if none is specified. Will work, but best if structure is explicit.
###################################

PARENTDIR=$(dirname "$DIRECTORY")
timestamp=$(date +%Y.%m.%d.%H.%M.%S)
SNAR=${CONFIG}${DIRECTORY}.snar
BASEDIR=$(basename ${DIRECTORY}/)
TAR=${BACKUPTO}${DIRECTORY}.${timestamp}.tar.gz



#Logic
# First Test if SNAR Dir Exists
# We do not need to make the SNAR as the tar utility 
# will create the defined tar if it does not exist. 
# However, Tar cannnot create the parent dir.
if dircheck "${CONFIG}${PARENTDIR}"; then
	echo "${CONFIG}${PARENTDIR} exists"
else
	makedir "${CONFIG}${PARENTDIR}"
	echo "created snar directory at ${CONFIG}${PARENTDIR}"
fi

# Test if full backup dir exists (parent only, as the 
# archive will be the actual directory in it's place).
if dircheck "${BACKUPTO}${PARENTDIR}"; then
	echo "${BACKUPTO}${PARENTDIR} exists" 
else
	makedir "${BACKUPTO}${PARENTDIR}"
	echo "created backup parent directory at ${BACKUPTO}${PARENTDIR}"
fi

if backup; then
	echo "backup completed successfully"
else
	echo "backup exited with an error"
fi

exit 0
