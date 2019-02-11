#!/usr/bin/env bash
##  @copyright 2018 DennyZhang.com
## Licensed under MIT 
##   https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: copy-to-vagrant.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2018-07-10>
## Updated: Time-stamp: <2019-02-09 22:34:08>
##-------------------------------------------------------------------
tar cz --directory . <filename> | vagrant ssh <hostname> -- 'tar xzf -'
