#!/usr/bin/env bash
##  @copyright 2018 DennyZhang.com
## Licensed under MIT 
##   https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: hello
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## https://unix.stackexchange.com/questions/365225/how-to-get-the-ipv4-address-for-an-interface-from-proc
## https://cheatsheet.dennyzhang.com/cheatsheet-process-A4
## --
## Created : <2018-10-06>
## Updated: Time-stamp: <2018-11-22 18:22:42>
##-------------------------------------------------------------------
ps -A -o stat,ppid,pid,cmd | grep '<defunct>'
