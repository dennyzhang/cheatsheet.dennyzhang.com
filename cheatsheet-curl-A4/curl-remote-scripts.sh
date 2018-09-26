#!/usr/bin/env bash
##  @copyright 2018 DennyZhang.com
## Licensed under MIT 
##   https://www.dennyzhang.com/wp-content/mit_license.txt
##
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2018-09-25>
## Updated: Time-stamp: <2018-09-25 17:42:39>
##-------------------------------------------------------------------
# https://starkandwayne.com/blog/build-bosh-releases-faster-with-language-packs/
bosh -d simple-go-web-app \
   deploy <(curl -L https://raw.githubusercontent.com/cloudfoundry-community/simple-go-web-app-boshrelease/master/manifests/simple-go-web-app.yml) \
   -o <(curl -L https://raw.githubusercontent.com/cloudfoundry-community/simple-go-web-app-boshrelease/master/manifests/operators/use-compiled-releases.yml)
