#!/bin/bash

#Example Use: /opt/scripts/backup/tarnation-restore.sh -d /root/test/backupfolder -b /gvault/backup/ -c /opt/scripts/backup/config/

#Process inputs
d_flag=''
b_flag=''
c_flag=''
l_flag=''
verbose='false'

while getopts 'd:b:c:l:v' flag; do
        case "${flag}" in
                d) d_flag=${OPTARG} ;;
                b) b_flag=${OPTARG} ;;
                c) c_flag=${OPTARG} ;;
				l) l_flag=${OPTARG} ;;
                v) verbose='true' ;;
                *) print_usage
                        exit 1 ;;
        esac
done

RESTORE=${d_flag%/}
BACKUPDIR=${b_flag%/}
PARENTRESTORE=$(dirname "$RESTORE")

cat ${BACKUPDIR}${RESTORE}* | tar -zxvf - -g /dev/null --ignore-zeros -C ${PARENTRESTORE}/

exit 0
