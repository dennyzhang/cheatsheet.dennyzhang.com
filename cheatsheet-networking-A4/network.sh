#!/usr/bin/env bash
##  @copyright 2020 DennyZhang.com
## Licensed under MIT 
##   https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: network.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2020-01-16>
## Updated: Time-stamp: <2020-01-16 11:15:24>
##-------------------------------------------------------------------
set -e

disable_ipv6 {
    # https://proprivacy.com/vpn/guides/disable-ipv6
    net.ipv6.conf.all.disable_ipv6 = 1
    net.ipv6.conf.default.disable_ipv6 = 1 
    net.ipv6.conf.lo.disable_ipv6 = 1

    sysctl -p
}
