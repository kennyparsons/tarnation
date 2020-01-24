#!/bin/bash

timestamp=`date '+%Y.%m.%d.%H.%M.%S'`

#find . -maxdepth 1 -mindepth 1 -type d -exec tar czf /root/test/{}.$timestamp.tar.gz {}  \;
#find /root/docker -maxdepth 1 -mindepth 1 -type d -exec tar czvf /root/test/{}.$timestamp.tar.gz {}  \;
cd /root/test
find . -maxdepth 1 -mindepth 1 -type d -prune -exec tar -czg /opt/backup/config/root/test/$(basename {} \)/ -f /gvault/backup/root/test/$(basename {} \).tar.gz \;
#BASEDIR=$(basename ${DIRECTORY}/)
#find . -maxdepth 1 -mindepth 1 -type d -exec tar -czg /opt/backup/config/root/test/{} -f /gvault/backup/root/test/{}.$timestamp.tar.gz {}  \;


find . -maxdepth 1 -mindepth 1 -type d -prune -exec sh -c 'tar -czg /opt/backup/config/root/test/$(basename {}).snar -f /gvault/backup/root/test/$(basename {}).tar.gz $(basename {})/' \;

find . -maxdepth 1 -mindepth 1 -type d -prune -exec sh -c 'cat /opt/backup/config/root/test/$(basename {}).snar
