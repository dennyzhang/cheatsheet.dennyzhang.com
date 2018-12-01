https://kubernetes.io/blog/2016/08/security-best-practices-kubernetes-deployment/

- Deploy one pod with root filesystem as readonly
```
kubectl apply -f ./kubernetes.yaml
kubectl get pods -l app=myapp
```

- Login to the pod, and try to create a dummy file under /root/
```
# As we can see, /root/a.txt can't be created, because /root is readonly
## ,-----------
## | bash-3.2$ kubectl exec -it myapp-pod sh
## | / # touch /root/a.txt
## | touch /root/a.txt
## | touch: /root/a.txt: Read-only file system
## `-----------

# The file mode of /root is drwx------
## ,-----------
## | / # ls -lth / | grep "root$"
## | ls -lth / | grep "root$"
## | drwx------    2 root     root        4.0K Jul 16 19:40 root
## `-----------
```

- Clean up
```
kubectl delete -f ./kubernetes.yaml
```
