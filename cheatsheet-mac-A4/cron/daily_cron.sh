#!/bin/bash -e
##-------------------------------------------------------------------
## File : daily_cron.sh
## Author : filebat <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2013-09-05>
## Updated: Time-stamp: <2018-10-18 10:08:59>
##-------------------------------------------------------------------
# 0 10 * * * ~/Dropbox/git_code/cheatsheet.dennyzhang.com/cheatsheet-mac-A4/cron/daily_cron.sh
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
        log "ERROR: run daily_cron.sh"
    fi
}

trap shell_exit SIGHUP SIGINT SIGTERM 0
################################################################################
LOG_FILE="/var/log/cron/daily_cron.log"

# cd "/Users/$(whoami)/git_code"
# curl -L https://raw.githubusercontent.com/dennyzhang/git_pull_folder/master/git_pull_folder.py | python

cd "/Users/$(whoami)/Dropbox/git_code/code.dennyzhang.com/"
git pull origin master
# bash automate.sh refresh_md
