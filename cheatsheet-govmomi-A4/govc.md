# Import govc

```
GOVC_INSECURE=1 GOVC_URL='administrator@vsphere.local:Admin!23@10.160.101.10' \
                govc import.ova --options=/root/tmp/ubuntu-16.04.json -ds=nfs0-1 \
                /root/tmp/ubuntu-16.04-server-cloudimg-amd64.ova
```
