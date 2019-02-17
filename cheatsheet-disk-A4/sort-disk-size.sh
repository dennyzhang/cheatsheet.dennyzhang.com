#!/usr/bin/env bash -e
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT
## https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: sort-disk-size.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2017-12-04>
## Updated: Time-stamp: <2019-02-10 22:02:49>
##-------------------------------------------------------------------
# Sort directories/files by size
du -sk * | sort -rn
