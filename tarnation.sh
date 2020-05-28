#!/bin/bash

# Author: Kenny Parsons
# Usage: Open Source
# Example: tarnation.sh -d /root/test -b /gvault/backup/ -c /opt/scripts/backup/config/ -l /opt/scripts/backup/tarnation.log

#Functions
backup(){
cd $PARENTDIR
tar -czg $SNAR -f $TAR $BASEDIR
}

restore(){
	cat ${BACKUPTO}${DIRECTORY}* | tar -zxvf - -g /dev/null --ignore-zeros -C ${PARENTDIR}/
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

log(){
	updatetime
	echo "${timestamp}	$1	$2	$3" >> $4 2>&1
}

updatetime(){
	timestamp=$(date +%Y.%m.%d.%H.%M.%S)
}

print_usage(){
        echo " "
        echo " * indicates a required option"
        echo "-d	[*] the directory being backed up"
        echo "-b 	[*] the backup destination root directory"
        echo "-c 	[*] the config/snar definition root directory"
        echo "-l 	[ ] the log file to be used "
				echo "-r 	[ ] puts the script in restore mode"
        echo "-v 	[ ] sets the logging to verbose"
}

#Process inputs
d_flag=''
b_flag=''
c_flag=''
l_flag=''
r_flag='false'
verbose='false'

while getopts 'd:b:c:l:rv' flag; do
        case "${flag}" in
                d) d_flag=${OPTARG} ;;
                b) b_flag=${OPTARG} ;;
                c) c_flag=${OPTARG} ;;
                l) l_flag=${OPTARG} ;;
                r) r_flag='true' ;;
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

if [ -z "$l_flag" ]; then
	# no log specified, put them in /tmp
    updatetime
	touch /tmp/${timestamp}.tarnation.log
	l_flag=/tmp/${timestamp}.tarnation.log
fi
#Universal Declarations
LOGFILE=${l_flag}
DIRECTORY=${d_flag%/}
BACKUPTO=${b_flag%/}
CONFIG=${c_flag%/}
PARENTDIR=$(dirname "$DIRECTORY")
BASEDIR=$(basename ${DIRECTORY}/)
SNAR=${CONFIG}${DIRECTORY}.snar



if [[ $r_flag == "true"* ]]; then

	log 'WARN' ${BASEDIR} 'restore started' ${LOGFILE}
	if restore; then
		log 'INFO' ${BASEDIR} 'restore completed' ${LOGFILE}
	else
		log 'ERROR' ${BASEDIR} 'restore exited with an error' ${LOGFILE}
	fi

	exit 0
fi

###################################
# Provided Variables
#No trailing slash


###################################


timestamp=$(date +%Y.%m.%d.%H.%M.%S)

#TAR=${BACKUPTO}${DIRECTORY}.${timestamp}.tar.gz

#Logic
log 'INFO' ${BASEDIR} ' backup started' ${LOGFILE}

# Test if SNAR File Exists
# If the SNAR does exist, we append increment to the archive name
# If the SNAR does not exist, we append full to the archive name
if filecheck "${SNAR}"; then
	BACKUPTYPE='increment'
else
	BACKUPTYPE='full'
fi

TAR=${BACKUPTO}${DIRECTORY}.${timestamp}.${BACKUPTYPE}.tar.gz

# Test if SNAR Dir Exists
# We do not need to make the SNAR as the tar utility
# will create the defined tar if it does not exist.
# However, Tar cannnot create the parent dir.
if dircheck "${CONFIG}${PARENTDIR}"; then
	log 'INFO' ${BASEDIR} '   snar directory ('${CONFIG}${PARENTDIR}') already exists' ${LOGFILE}
else
	makedir "${CONFIG}${PARENTDIR}"
	log 'NOTE' ${BASEDIR} '   created snar directory at '${CONFIG}${PARENTDIR} ${LOGFILE}
fi

# Test if full backup dir exists (parent only, as the
# archive will be the actual directory in it's place).
if dircheck "${BACKUPTO}${PARENTDIR}"; then
	log 'INFO' ${BASEDIR} '   backup parent directory ('${BACKUPTO}${PARENTDIR}') exists' ${LOGFILE}
else
	makedir "${BACKUPTO}${PARENTDIR}"
	log 'NOTE' ${BASEDIR} '   created backup parent directory at '${BACKUPTO}${PARENTDIR} ${LOGFILE}
fi

if backup; then
	log 'INFO' ${BASEDIR} '   tar.gz completed at '${TAR} ${LOGFILE}
	log 'INFO' ${BASEDIR} ' '${BACKUPTYPE}' backup completed successfully' ${LOGFILE}
else
	log 'ERROR' ${BASEDIR} ' '${BACKUPTYPE}' backup exited with an error' ${LOGFILE}
fi

exit 0
