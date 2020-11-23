#!/bin/sh

# server address:port --auth username:password
SERVER="127.0.0.1:9091"
# destination log file
SEEDING_LOG="/config/seeding.log"
# get torrents id
TORRENTLIST=`transmission-remote $SERVER --list | tail -n +2 | head -n -1 | awk '{print $1}'`

# Final time is 15 days in seconds
FINAL_TIME="1296000"
REAL_TIME=$(date +"%Y-%d-%m %T")
CURRENT_DATE=`date +%s`

echo "$REAL_TIME ***** Processing *****" >> $SEEDING_LOG
# for each torrent in the list
for TORRENTID in $TORRENTLIST
do
    CURRENT_NAME=`transmission-remote $SERVER --torrent $TORRENTID --info | grep "Name: " | awk '{print substr($2,0,40)}'`
    TORRENT_DATE=`transmission-remote $SERVER --torrent $TORRENTID --info | grep "Date added" | awk '{print $3,$4,$5,$6}'`
    TORRENT_DATE_FORMATTED=$(date -d "$TORRENT_DATE" +%s)
    TORRENT_AGE_SECONDS=$(($CURRENT_DATE - $TORRENT_DATE_FORMATTED))
    echo -n "$REAL_TIME Seeding-time of $CURRENT_NAME " >> $SEEDING_LOG
    if [ $TORRENT_AGE_SECONDS -gt $FINAL_TIME ]
    then
        echo "is $TORRENT_AGE_SECONDS seconds. More than $FINAL_TIME. Deleting" >> $SEEDING_LOG
        echo "$REAL_TIME Removing torrent and deleting files" >> $SEEDING_LOG
        transmission-remote $SERVER --torrent $TORRENTID --remove-and-delete
    else
        echo "is $TORRENT_AGE_SECONDS seconds. Less than $FINAL_TIME. Ignoring." >> $SEEDING_LOG
    fi
done
