#!/usr/bin/env bash
##  @copyright 2018 DennyZhang.com
## Licensed under MIT 
##   https://www.dennyzhang.com/wp-content/mit_license.txt
##
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2018-09-25>
## Updated: Time-stamp: <2018-09-25 17:40:31>
##-------------------------------------------------------------------
curl -XGET http://${elasticsearch_ip}:9200/_cluster/nodes | python -m json.tool
