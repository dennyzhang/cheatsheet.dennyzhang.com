#!/usr/bin/env bash
export cb_username="Administrator"
export cb_passwd="mypasswd"

for bucket in "bucket1" "bucket2" "bucket3"; do
    echo "flush cb bucket: $bucket"
    couchbase-cli bucket-flush -c localhost:8091 -u "$cb_username" \
     -p "$cb_passwd" --force --bucket "$bucket"
done
