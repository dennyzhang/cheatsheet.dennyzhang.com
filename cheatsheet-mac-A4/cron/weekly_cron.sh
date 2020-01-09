#!/bin/bash -e
##-------------------------------------------------------------------
## File : weekly_cron.sh
## Author : filebat <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2013-09-05>
## Updated: Time-stamp: <2019-09-22 22:04:00>
##-------------------------------------------------------------------
# 0 20 * * 0 ~/Dropbox/git_code/cheatsheet.dennyzhang.com/cheatsheet-mac-A4/cron/weekly_cron.sh

function log() {
    local msg=$*
    date_timestamp=$(date +['%Y-%m-%d %H:%M:%S'])
    echo -ne "$date_timestamp $msg\\n"
    
    if [ -n "$LOG_FILE" ]; then
        echo -ne "$date_timestamp $msg\\n" >> "$LOG_FILE"
    fi
}

function shell_exit {
    errcode=$?
    if [ $errcode -ne 0 ]; then
        log "ERROR: unexpected error"
    fi
}

trap shell_exit SIGHUP SIGINT SIGTERM 0
LOG_FILE="/var/log/cron/weekly_cron.log"
date=$(date +'%Y%m%d')
log "Start to run weekly_cron.sh"

if [ -f /var/mail/mac ]; then
    > /var/mail/mac
fi

for d in "cheatsheet.dennyzhang.com" \
             "quiz.dennyzhang.com" \
             "architect.dennyzhang.com" \
             "code.dennyzhang.com" \
             "challenges-kubernetes" \
             "www.dennyzhang.com"; do
    cd "/Users/zdenny/Dropbox/git_code/$d"
    echo "Recursively git push in $d"
    make git-push >> /var/log/cron/weekly_git_publish_$d.log

    echo "Recursively git pull in $d"
    make git-pull >> /var/log/cron/weekly_git_publish_$d.log

    # echo "Recursively update wordpress in $d"
    # make refresh-wordpress >> /var/log/cron/weekly_git_publish_$d.log
done

cd "/Users/zdenny/Dropbox/git_code/cheatsheet.dennyzhang.com"
echo "Refresh cheatsheet pdf"
make refresh-cheatsheet >> /var/log/cron/weekly_refresh_cheatsheet.log
log "Succeed to run weekly_cron.sh"
## File : weekly_cron.sh ends
