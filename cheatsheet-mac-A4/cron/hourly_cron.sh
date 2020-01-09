#!/bin/bash -e
##-------------------------------------------------------------------
## File : hourly_cron.sh
## Author : filebat <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2013-09-05>
## Updated: Time-stamp: <2018-10-18 10:09:18>
##-------------------------------------------------------------------
# 0 * * * * ~/Dropbox/git_code/cheatsheet.dennyzhang.com/cheatsheet-mac-A4/cron/hourly_cron.sh
function log {
    local msg=$*
    date_timestamp=$(date +['%Y-%m-%d %H:%M:%S'])
    echo -ne "$date_timestamp $msg\\n"

    if [ -n "$LOG_FILE" ]; then
        echo -ne "$date_timestamp $msg\\n" >> "$LOG_FILE"
    fi
}

function shell_exit {
    errcode=$?
    if [ $errcode -eq 0 ]; then
        echo "OK"
    else
        log "ERROR: run hourly_cron.sh"
    fi
}

trap shell_exit SIGHUP SIGINT SIGTERM 0
################################################################################
LOG_FILE="/var/log/cron/hourly_cron.log"

echo "start to run hourly_cron.sh"
cd "/Users/$(whoami)/Dropbox/private_data/work/vmware/code"
curl -L https://raw.githubusercontent.com/dennyzhang/git_pull_folder/master/git_pull_folder.py | python

cd "/Users/$(whoami)/go/src/github.com"
curl -L https://raw.githubusercontent.com/dennyzhang/git_pull_folder/master/git_pull_folder.py | python

# echo "fetch emails"
# bash $HOME/Dropbox/private_data/emacs_stuff/backup_small/fetch_mail/fetch_mail.sh

echo "Succeed to run hourly_cron.sh"
## File : hourly_cron.sh ends
