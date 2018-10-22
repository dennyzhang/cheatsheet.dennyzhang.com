Table of Contents
=================

   * [Check in minikube](#check-in-minikube)
   * [Check etcd data folder in minikube](#check-etcd-data-folder-in-minikube)
   * [Query etcd](#query-etcd)
   * [Create mysql test](#create-mysql-test)
   * [Confirm PV/PVC in etcd](#confirm-pvpvc-in-etcd)
   * [Query etcd for pv and pvc info](#query-etcd-for-pv-and-pvc-info)
   * [Useful link](#useful-link)

Explore what data is stored in kubernetes etcd

# Check in minikube
```
minikube ssh

sudo su -

ps -ef | grep curl

## ,----------- Sample Output
## | $ ps -ef | grep etcd
## | root      3226  3203  3 Jul18 ?        00:44:15 kube-apiserver --admission-control=Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota --requestheader-group-headers=X-Remote-Group --advertise-address=192.168.99.100 --tls-cert-file=/var/lib/localkube/certs/apiserver.crt --tls-private-key-file=/var/lib/localkube/certs/apiserver.key --kubelet-client-certificate=/var/lib/localkube/certs/apiserver-kubelet-client.crt --proxy-client-cert-file=/var/lib/localkube/certs/front-proxy-client.crt --proxy-client-key-file=/var/lib/localkube/certs/front-proxy-client.key --insecure-port=0 --allow-privileged=true --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --kubelet-client-key=/var/lib/localkube/certs/apiserver-kubelet-client.key --secure-port=8443 --requestheader-client-ca-file=/var/lib/localkube/certs/front-proxy-ca.crt --requestheader-username-headers=X-Remote-User --requestheader-extra-headers-prefix=X-Remote-Extra- --service-account-key-file=/var/lib/localkube/certs/sa.pub --client-ca-file=/var/lib/localkube/certs/ca.crt --enable-bootstrap-token-auth=true --requestheader-allowed-names=front-proxy-client --service-cluster-ip-range=10.96.0.0/12 --authorization-mode=Node,RBAC --etcd-servers=https://127.0.0.1:2379 --etcd-cafile=/var/lib/localkube/certs/etcd/ca.crt --etcd-certfile=/var/lib/localkube/certs/apiserver-etcd-client.crt --etcd-keyfile=/var/lib/localkube/certs/apiserver-etcd-client.key
## | root      3338  3272  1 Jul18 ?        00:15:21 etcd --data-dir=/data/minikube --key-file=/var/lib/localkube/certs/etcd/server.key --peer-cert-file=/var/lib/localkube/certs/etcd/peer.crt --peer-key-file=/var/lib/localkube/certs/etcd/peer.key --peer-trusted-ca-file=/var/lib/localkube/certs/etcd/ca.crt --client-cert-auth=true --peer-client-cert-auth=true --cert-file=/var/lib/localkube/certs/etcd/server.crt --trusted-ca-file=/var/lib/localkube/certs/etcd/ca.crt --listen-client-urls=https://127.0.0.1:2379 --advertise-client-urls=https://127.0.0.1:2379
## `-----------
```

# Check etcd data folder in minikube

```
ls -lth /data/minikube/*/*

## ,-----------
## | # ls -lth /data/minikube/*/*
## | /data/minikube/member/snap:
## | total 3.3M
## | -rw------- 1 root root  19M Jul 19 04:20 db
## | -rw-r--r-- 1 root root 7.3K Jul 19 04:13 0000000000000003-0000000000041ecb.snap
## | -rw-r--r-- 1 root root 7.3K Jul 18 23:32 0000000000000003-000000000003f7ba.snap
## | -rw-r--r-- 1 root root 7.3K Jul 18 21:03 0000000000000003-000000000003d0a9.snap
## | -rw-r--r-- 1 root root 7.3K Jul 18 18:34 0000000000000003-000000000003a998.snap
## | -rw-r--r-- 1 root root 7.3K Jul 18 06:30 0000000000000003-0000000000038287.snap
## | 
## | /data/minikube/member/wal:
## | total 367M
## | -rw------- 1 root root 62M Jul 19 04:20 0000000000000004-0000000000041514.wal
## | -rw------- 1 root root 62M Jul 19 01:22 0.tmp
## | -rw------- 1 root root 62M Jul 19 01:22 0000000000000003-0000000000031e3d.wal
## | -rw------- 1 root root 62M Jul 17 20:58 0000000000000002-0000000000022257.wal
## | -rw------- 1 root root 62M Jul 16 05:16 0000000000000001-00000000000110d1.wal
## | -rw------- 1 root root 62M Jul 13 20:41 0000000000000000-0000000000000000.wal
## `-----------
```

# Query etcd

```
# Inside minikube, found etcd container
docker ps | grep etcd
## ,-----------
## | $ docker ps | grep etcd
## | ec52f93666d2        52920ad46f5b                                    "etcd --data-dir=/da…"   36 hours ago        Up 36 hours                             k8s_etcd_etcd-minikube_kube-system_dc7c2a29e86f22cde1fcb7d6eaadc95e_0
## | ca241ffe10bf        k8s.gcr.io/pause-amd64:3.1                      "/pause"                 36 hours ago        Up 36 hours                             k8s_POD_etcd-minikube_kube-system_dc7c2a29e86f22cde1fcb7d6eaadc95e_0
## `-----------

docker exec -it ec52f93666d2 sh

# Run sample query: member list

command_prefix="etcdctl --endpoints 127.0.0.1:2379 --cacert /var/lib/localkube/certs/etcd/ca.crt --cert /var/lib/localkube/certs/etcd/peer.crt --key /var/lib/localkube/certs/etcd/peer.key"
ETCDCTL_API=3 $command_prefix member list
## ,----------- Sample Output
## | / # $command_prefix member list
## | 2018-07-19 04:52:38.396931 I | warning: ignoring ServerName for user-provided CA for backwards compatibility is deprecated
## | 8e9e05c52164694d: name=default peerURLs=http://localhost:2380 clientURLs=https://127.0.0.1:2379 isLeader=true
## `-----------

# https://kubernetes-v1-4.github.io/docs/admin/etcd/
# By default, Kubernetes objects are stored under the /registry key in etcd.

ETCDCTL_API=3 $command_prefix get /registry/namespaces/default -w=json
## ,----------- Sample Ouptut
## | / # ETCDCTL_API=3 $command_prefix get /registry/namespaces/default -w=json
## | 2018-07-19 04:58:49.768085 I | warning: ignoring ServerName for user-provided CA for backwards compatibility is deprecated
## | {"header":{"cluster_id":14841639068965178418,"member_id":10276657743932975437,"revision":266852,"raft_term":3},"kvs":[{"key":"L3JlZ2lzdHJ5L25hbWVzcGFjZXMvZGVmYXVsdA==","create_revision":6,"mod_revision":6,"version":1,"value":"azhzAAoPCgJ2MRIJTmFtZXNwYWNlEl8KRQoHZGVmYXVsdBIAGgAiACokMmM5MGY5ZDUtODVhMy0xMWU4LTg5YWQtMDgwMDI3Y2JhZWE0MgA4AEIICML/m9oFEAB6ABIMCgprdWJlcm5ldGVzGggKBkFjdGl2ZRoAIgA="}],"count":1}
## `-----------
```

# Create mysql test
[kubernetes.yaml](kubernetes.yaml):
- Create namespace: ns-test
- Create PV: 5GB local disk
- Create PVC: In ns-test namespace, create one PVC
- Create deployment and service: mysql. This db service will use the PVC

```
kubectl apply -f ./kubernetes.yaml

kubectl get pvc -n ns-test
## ,-----------
## | bash-3.2$ kubectl get pvc -n ns-test
## | NAME         STATUS    VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
## | mysql001-1   Bound     pvc-5a949e51-8b11-11e8-a8c8-080027cbaea4   5Gi        RWO            standard       5s
## `-----------

kubectl get pod -n ns-test
## ,-----------
## | bash-3.2$ kubectl get pod -n ns-test
## | NAME                                   READY     STATUS    RESTARTS   AGE
## | dbserver-deployment-7c76884dbf-xjq9t   1/1       Running   0          40s
## `-----------
```


``` Sample Output
## ,-----------
## | bash-3.2$ kubectl get pvc -n ns-test
## | NAME         STATUS    VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
## | mysql001-1   Bound     pvc-5a949e51-8b11-11e8-a8c8-080027cbaea4   5Gi        RWO            standard       25m
## `-----------

## ,-----------
## | bash-3.2$ kubectl get pv
## | NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                STORAGECLASS   REASON    AGE
## | mysql001                                   5Gi        RWO            Retain           Available                                                 27m
## | pvc-5a949e51-8b11-11e8-a8c8-080027cbaea4   5Gi        RWO            Delete           Bound       ns-test/mysql001-1   standard                 27m
## `-----------
```

# Confirm PV/PVC in etcd

```
ETCDCTL_API=3 $command_prefix get /registry --prefix -w=json > /tmp/test.json

# Copy /tmp/test.json to local
keys=$(cat /tmp/test.json | python -m json.tool|grep key|cut -d ":" -f2|tr -d '"'|tr -d ",")
for x in $keys;do
  echo $x | base64 -D| sort | grep persist
done

## ,----------- Sample Output
## |> > /registry/clusterrolebindings/system:controller:persistent-volume-binder
## |/registry/clusterroles/system:controller:persistent-volume-binder
## |/registry/clusterroles/system:persistent-volume-provisioner
## |/registry/persistentvolumeclaims/ns-test/mysql001-1
## |/registry/persistentvolumes/mysql001
## |/registry/persistentvolumes/pvc-5a949e51-8b11-11e8-a8c8-080027cbaea4
## |/registry/secrets/kube-system/persistent-volume-binder-token-zfxjl
## |/registry/serviceaccounts/kube-system/persistent-volume-binder
## `-----------
```

# Query etcd for pv and pvc info

- check pv
```
ETCDCTL_API=3 $command_prefix get /registry/persistentvolumes/mysql001 -w=json

## ,----------- Sample Output
## | / # ETCDCTL_API=3 $command_prefix get /registry/persistentvolumes/mysql001 -w=json
## | 2018-07-19 05:35:37.199030 I | warning: ignoring ServerName for user-provided CA for backwards compatibility is deprecated
## | {"header":{"cluster_id":14841639068965178418,"member_id":10276657743932975437,"revision":269343,"raft_term":3},"kvs":[{"key":"L3JlZ2lzdHJ5L3BlcnNpc3RlbnR2b2x1bWVzL215c3FsMDAx","create_revision":267293,"mod_revision":267301,"version":3,"value":"azhzAAoWCgJ2MRIQUGVyc2lzdGVudFZvbHVtZRLzAwqcAwoIbXlzcWwwMDESABoAIgAqJDVhOGJhYzNkLThiMTEtMTFlOC1hOGM4LTA4MDAyN2NiYWVhNDIAOABCCAiYuMDaBRAAWg0KBHR5cGUSBWxvY2FsYqcCCjBrdWJlY3RsLmt1YmVybmV0ZXMuaW8vbGFzdC1hcHBsaWVkLWNvbmZpZ3VyYXRpb24S8gF7ImFwaVZlcnNpb24iOiJ2MSIsImtpbmQiOiJQZXJzaXN0ZW50Vm9sdW1lIiwibWV0YWRhdGEiOnsiYW5ub3RhdGlvbnMiOnt9LCJsYWJlbHMiOnsidHlwZSI6ImxvY2FsIn0sIm5hbWUiOiJteXNxbDAwMSIsIm5hbWVzcGFjZSI6IiJ9LCJzcGVjIjp7ImFjY2Vzc01vZGVzIjpbIlJlYWRXcml0ZU9uY2UiXSwiY2FwYWNpdHkiOnsic3RvcmFnZSI6IjVHaSJ9LCJob3N0UGF0aCI6eyJwYXRoIjoiL2RhdGEvbXlzcWwwMDEifX19CnIba3ViZXJuZXRlcy5pby9wdi1wcm90ZWN0aW9uegASQQoQCgdzdG9yYWdlEgUKAzVHaRIUGhIKDi9kYXRhL215c3FsMDAxEgAaDVJlYWRXcml0ZU9uY2UqBlJldGFpbjIAGg8KCUF2YWlsYWJsZRIAGgAaACIA"}],"count":1}
## `-----------

# Decode key

## ,-----------
## | / # echo L3JlZ2lzdHJ5L3BlcnNpc3RlbnR2b2x1bWVzL215c3FsMDAx | base64 -d
## | /registry/persistentvolumes/mysql001/ #
## `-----------

# Decode value

echo azhzAAoWCgJ2MRIQUGVyc2lzdGVudFZvbHVtZRLzAwqcAwoIbXlzcWwwMDESABoAIgAqJDVhOGJhYzNkLThiMTEtMTFlOC1hOGM4LTA4MDAyN2NiYWVhNDIAOABCCAiYuMDaBRAAWg0KBHR5cGUSBWxvY2FsYqcCCjBrdWJlY3RsLmt1YmVybmV0ZXMuaW8vbGFzdC1hcHBsaWVkLWNvbmZpZ3VyYXRpb24S8gF7ImFwaVZlcnNpb24iOiJ2MSIsImtpbmQiOiJQZXJzaXN0ZW50Vm9sdW1lIiwibWV0YWRhdGEiOnsiYW5ub3RhdGlvbnMiOnt9LCJsYWJlbHMiOnsidHlwZSI6ImxvY2FsIn0sIm5hbWUiOiJteXNxbDAwMSIsIm5hbWVzcGFjZSI6IiJ9LCJzcGVjIjp7ImFjY2Vzc01vZGVzIjpbIlJlYWRXcml0ZU9uY2UiXSwiY2FwYWNpdHkiOnsic3RvcmFnZSI6IjVHaSJ9LCJob3N0UGF0aCI6eyJwYXRoIjoiL2RhdGEvbXlzcWwwMDEifX19CnIba3ViZXJuZXRlcy5pby9wdi1wcm90ZWN0aW9uegASQQoQCgdzdG9yYWdlEgUKAzVHaRIUGhIKDi9kYXRhL215c3FsMDAxEgAaDVJlYWRXcml0ZU9uY2UqBlJldGFpbjIAGg8KCUF2YWlsYWJsZRIAGgAaACIA | base64 -d

## ,-----------
## | / # echo azhzAAoWCgJ2MRIQUGVyc2lzdGVudFZvbHVtZRLzAwqcAwoIbXlzcWwwMDESABoAIgAqJDV
## | hOGJhYzNkLThiMTEtMTFlOC1hOGM4LTA4MDAyN2NiYWVhNDIAOABCCAiYuMDaBRAAWg0KBHR5cGUSBWx
## | vY2FsYqcCCjBrdWJlY3RsLmt1YmVybmV0ZXMuaW8vbGFzdC1hcHBsaWVkLWNvbmZpZ3VyYXRpb24S8gF
## | 7ImFwaVZlcnNpb24iOiJ2MSIsImtpbmQiOiJQZXJzaXN0ZW50Vm9sdW1lIiwibWV0YWRhdGEiOnsiYW5
## | ub3RhdGlvbnMiOnt9LCJsYWJlbHMiOnsidHlwZSI6ImxvY2FsIn0sIm5hbWUiOiJteXNxbDAwMSIsIm5
## | hbWVzcGFjZSI6IiJ9LCJzcGVjIjp7ImFjY2Vzc01vZGVzIjpbIlJlYWRXcml0ZU9uY2UiXSwiY2FwYWN
## | pdHkiOnsic3RvcmFnZSI6IjVHaSJ9LCJob3N0UGF0aCI6eyJwYXRoIjoiL2RhdGEvbXlzcWwwMDEifX1
## | 9CnIba3ViZXJuZXRlcy5pby9wdi1wcm90ZWN0aW9uegASQQoQCgdzdG9yYWdlEgUKAzVHaRIUGhIKDi9
## | kYXRhL215c3FsMDAxEgAaDVJlYWRXcml0ZU9uY2UqBlJldGFpbjIAGg8KCUF2YWlsYWJsZRIAGgAaACI
## | A | base64 -d
## | k8s
## | 
## | v1PersistentVolume
## | 
## | mysql001"*$5a8bac3d-8b11-11e8-a8c8-080027cbaea42ZB
## | typelocalb
## | 0kubectl.kubernetes.io/last-applied-configuration{"apiVersion":"v1","kind":"PersistentVolume","metadata":{"annotations":{},"labels":{"type":"local"},"name":"mysql001","namespace":""},"spec":{"accessModes":["ReadWriteOnce"],"capacity":{"storage":"5Gi"},"hostPath":{"path":"/data/mysql001"}}}
## | r
## | ReadWriteOnce*Retain2
## |         Available"/ #
## `-----------
```

- Check pvc

```
ETCDCTL_API=3 $command_prefix get /registry/persistentvolumeclaims/ns-test/mysql001-1 -w=json

## ,-----------
## | / # ETCDCTL_API=3 $command_prefix get /registry/persistentvolumeclaims/ns-test/mysql001-1 -w=json
## | 2018-07-19 05:38:27.400400 I | warning: ignoring ServerName for user-provided CA for backwards compatibility is deprecated
## | {"header":{"cluster_id":14841639068965178418,"member_id":10276657743932975437,"revision":269530,"raft_term":3},"kvs":[{"key":"L3JlZ2lzdHJ5L3BlcnNpc3RlbnR2b2x1bWVjbGFpbXMvbnMtdGVzdC9teXNxbDAwMS0x","create_revision":267296,"mod_revision":267388,"version":21,"value":"azhzAAobCgJ2MRIVUGVyc2lzdGVudFZvbHVtZUNsYWltEvsGCvUFCgpteXNxbDAwMS0xEgAaB25zLXRlc3QiACokNWE5NDllNTEtOGIxMS0xMWU4LWE4YzgtMDgwMDI3Y2JhZWE0MgA4AEIICJi4wNoFEABi3gEKKGNvbnRyb2wtcGxhbmUuYWxwaGEua3ViZXJuZXRlcy5pby9sZWFkZXISsQF7ImhvbGRlcklkZW50aXR5IjoiMzkwNDJjYjItODllMi0xMWU4LTlkZWEtMDgwMDI3Y2JhZWE0IiwibGVhc2VEdXJhdGlvblNlY29uZHMiOjE1LCJhY3F1aXJlVGltZSI6IjIwMTgtMDctMTlUMDU6MDU6MjhaIiwicmVuZXdUaW1lIjoiMjAxOC0wNy0xOVQwNTowNTo1OVoiLCJsZWFkZXJUcmFuc2l0aW9ucyI6MH1ihAIKMGt1YmVjdGwua3ViZXJuZXRlcy5pby9sYXN0LWFwcGxpZWQtY29uZmlndXJhdGlvbhLPAXsiYXBpVmVyc2lvbiI6InYxIiwia2luZCI6IlBlcnNpc3RlbnRWb2x1bWVDbGFpbSIsIm1ldGFkYXRhIjp7ImFubm90YXRpb25zIjp7fSwibmFtZSI6Im15c3FsMDAxLTEiLCJuYW1lc3BhY2UiOiJucy10ZXN0In0sInNwZWMiOnsiYWNjZXNzTW9kZXMiOlsiUmVhZFdyaXRlT25jZSJdLCJyZXNvdXJjZXMiOnsicmVxdWVzdHMiOnsic3RvcmFnZSI6IjVHaSJ9fX19CmImCh9wdi5rdWJlcm5ldGVzLmlvL2JpbmQtY29tcGxldGVkEgN5ZXNiKwokcHYua3ViZXJuZXRlcy5pby9ib3VuZC1ieS1jb250cm9sbGVyEgN5ZXNiSQotdm9sdW1lLmJldGEua3ViZXJuZXRlcy5pby9zdG9yYWdlLXByb3Zpc2lvbmVyEhhrOHMuaW8vbWluaWt1YmUtaG9zdHBhdGhyHGt1YmVybmV0ZXMuaW8vcHZjLXByb3RlY3Rpb256ABJXCg1SZWFkV3JpdGVPbmNlEhISEAoHc3RvcmFnZRIFCgM1R2kaKHB2Yy01YTk0OWU1MS04YjExLTExZTgtYThjOC0wODAwMjdjYmFlYTQqCHN0YW5kYXJkGigKBUJvdW5kEg1SZWFkV3JpdGVPbmNlGhAKB3N0b3JhZ2USBQoDNUdpGgAiAA=="}],"count":1}
## | / #
## `-----------

# Decode key
## ,-----------
## | / # echo L3JlZ2lzdHJ5L3BlcnNpc3RlbnR2b2x1bWVjbGFpbXMvbnMtdGVzdC9teXNxbDAwMS0x | base64 -d
## | /registry/persistentvolumeclaims/ns-test/mysql001-1/ #
## `-----------

# Decode value

## ,-----------
## | / # echo "azhzAAoPCgJ2MRIJTmFtZXNwYWNlEvwBCuEBCgducy10ZXN0EgAaACIAKiQ1YTgxNWQyYy
## | 04YjExLTExZTgtYThjOC0wODAwMjdjYmFlYTQyADgAQggImLjA2gUQAGKZAQowa3ViZWN0bC5rdWJlcm
## | 5ldGVzLmlvL2xhc3QtYXBwbGllZC1jb25maWd1cmF0aW9uEmV7ImFwaVZlcnNpb24iOiJ2MSIsImtpbm
## | QiOiJOYW1lc3BhY2UiLCJtZXRhZGF0YSI6eyJhbm5vdGF0aW9ucyI6e30sIm5hbWUiOiJucy10ZXN0Ii
## | wibmFtZXNwYWNlIjoiIn19CnoAEgwKCmt1YmVybmV0ZXMaCAoGQWN0aXZlGgAiAA==" | base64 -d
## | k8s
## | 
## | v1      Namespace
## | 
## | ns-test"*$5a815d2c-8b11-11e8-a8c8-080027cbaea42bB
## | 0kubectl.kubernetes.io/last-applied-configuratione{"apiVersion":"v1","kind":"Namespace","metadata":{"annotations":{},"name":"ns-test","namespace":""}}
## | z
## | 
## | 
## | kubernetes
## | Active"/ #
## `-----------
```
From above, we have confirmed whenever we create PV or PVC, k8s will store the metatdata in etcd.

# Useful link

```
https://stackoverflow.com/questions/47807892/how-to-access-kubernetes-keys-in-etcd
https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/
https://github.com/rootsongjc/kubernetes-handbook/blob/master/guide/using-etcdctl-to-access-kubernetes-data.md
https://coreos.com/etcd/docs/latest/v2/api.html
https://coreos.com/etcd/docs/latest/dev-guide/interacting_v3.html
```
