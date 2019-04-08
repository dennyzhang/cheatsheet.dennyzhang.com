# Deploy a Concourse Instance on Nimbus
```
/mts/git/bin/nimbus-testbeddeploy \
    --testbedSpecRubyFile http://sc-dbc1216.eng.vmware.com/zdenny/download/quick-concourse-testbed.rb \
    --noStatsDump --noSupportBundles --keepVMsOnFailure --runName concourse
```

```
-bash-4.1$ cat /tmp/nimbus-test-zdenny/standalone-2b257db3b/testbedInfo.json
{
  "concourse": "http://10.192.63.200:8080",
  "concourse_version": "5.0.0",
  "type": "concourse-testbed-0-workers",
  "name": "concourse",
  "user_name": "zdenny",
  "podname": "sc-prd-vc042",
  "nimbusLocation": "sc",
  "vc": [

  ],
  "iscsi": [

  ],
  "nfs": [

  ],
  "hostdSim": [

  ],
  "mobAgent": [

  ],
  "vcg": [

  ],
  "genericVm": [

  ],
  "pdpVm": [

  ],
  "ovfVm": [
    {
      "name": "zdenny-concourse.ovfVm.0",
      "ip": "10.192.63.200",
      "ip4": "10.192.63.200",
      "ip6": null,
      "username": "worker",
      "password": "ca$hc0w",
      "vm_resource": {
        "vmName": "zdenny-concourse.ovfVm.0",
        "vmMemory": 4096,
        "vmMemoryReservation": 1024,
        "numCpus": 2,
        "vmCpu": 2500,
        "vmCpuReservation": 800,
        "diskSize": 83886080
      },
      "dependencies": [

      ],
      "pod": "sc-prd-vc042",
      "givenName": "zdenny-concourse.ovfVm.0",
      "systemPNID": null
    }
  ],
  "vsm": [

  ],
  "vcd": [

  ],
  "esx": [

  ],
  "vcBench": [

  ],
  "psa": [

  ],
  "vrops": [

  ],
  "fiaasco": [

  ],
  "vropssol": [

  ],
  "vraCafe": [

  ],
  "vraSso": [

  ],
  "logInsight": [

  ],
  "network": [

  ],
  "sampleVm": [

  ],
  "nsxm": [

  ],
  "nsxc": [

  ],
  "vnimbus": [

  ],
  "vr": [

  ],
  "vcaCgw": [

  ],
  "vcaWanopt": [

  ],
  "ucp": [

  ],
  "worker": [

  ],
  "nsxAutoEdge": [

  ],
  "deployment_result": "PASS"
}
```
