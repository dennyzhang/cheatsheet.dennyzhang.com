#!/usr/bin/env bash -e
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT
## https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: setup_mac.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2017-12-04>
## Updated: Time-stamp: <2020-06-07 20:38:40>
##-------------------------------------------------------------------
set -e

function verify_binary {
    bin_file=${1?}
    hint_msg=${2?}
    if ! which $bin_file; then
        echo "Error: $bin_file is not found. hint: $hint_msg"
        exit 1
    fi
}

verify_binary "pdflatex" "Check http://www.tug.org/mactex/mactex-download.html"
