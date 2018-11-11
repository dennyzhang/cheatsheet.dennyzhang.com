#!/usr/bin/env bash
# http://www.couchbase.com/forums/thread/execute-command-node-init-data-path-path-not-changing
# Reset couchbase passwd
couchbase-cli cluster-init -c 127.0.0.1:8091 \
              -u $username:$passwd --cluster-init-username=Administrator \
              --cluster-init-password=$passwd

# Initialize couchbase cluster
couchbase-cli cluster-init -c 127.0.0.1:8091 \
              -u $username:$passwd --cluster-init-username=Administrator \
              --cluster-init-password=password --node-init-data-path=/app/couchbase/data

# Create bucket
couchbase-cli bucket-create -c localhost -u Administrator -p password1234 \
       --bucket=cloudpass \
       --bucket-type=couchbase \
       --bucket-password= \
       --bucket-ramsize=200 \
       --enable-flush=1 \
       --enable-index-replica=1

# Load sample data
cd /opt/couchbase/bin
./cbdocloader -u $username:$passwd -n 127.0.0.1:8091 -b mybucket ../samples/beer-sample.zip
