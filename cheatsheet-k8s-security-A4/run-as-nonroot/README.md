
- Build and push docker image

By default node image will create a non-root user (node)

But in the default Dockerfile, it would still be root. (See [here](https://github.com/nodejs/docker-node/blob/e3ec2111af089e31321e76641697e154b3b6a6c3/8/alpine/Dockerfile#L5))

Here we build a docker image, changing default user. (See [Dockerfile](Dockerfile))

```
docker build --no-cache -t denny/node:alphine --rm=true .
docker push denny/node:alphine
```

- Deploy one pod with runAsNonRoot as true
```
kubectl apply -f ./kubernetes.yaml
kubectl get pods -l app=myapp --all-namespaces
## ,-----------
## | bash-3.2$ kubectl get pods -l app=myapp --all-namespaces
## | NAMESPACE   NAME        READY     STATUS    RESTARTS   AGE
## | default     myapp-pod   1/1       Running   0          27s
## `-----------
```

- In kubernetes.yaml, use image of node:alphine

Now deploy again, the pod won't start
```
# destroy the previous one
kubectl delete -f ./kubernetes.yaml
```

- edit kubernetes.yaml

```
# deploy again
kubectl apply -f ./kubernetes.yaml

# check status
kubectl get pods -l app=myapp --all-namespaces

## ,-----------
## | bash-3.2$ kubectl get pods -l app=myapp --all-namespaces
## | NAMESPACE   NAME        READY     STATUS                       RESTARTS   AGE
## | default     myapp-pod   0/1       CreateContainerConfigError   0          8s
## `-----------

kubectl describe pod myapp-pod

## ,-----------
## | bash-3.2$ kubectl describe pod myapp-pod
## | Name:         myapp-pod
## | Namespace:    default
## | Node:         minikube/10.0.2.15
## | Start Time:   Sun, 29 Jul 2018 16:56:26 -0700
## | Labels:       app=myapp
## | Annotations:  kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"labels":{"app":"myapp"},"name":"myapp-pod","namespace":"default"},"spec":{"containers":[{...
## | Status:       Pending
## | IP:           172.17.0.19
## | Containers:
## |   myapp-container:
## |     Container ID:  
## |     Image:         node:alpine
## |     Image ID:      
## |     Port:          <none>
## |     Host Port:     <none>
## |     Command:
## |       sh
## |       -c
## |       echo Hello Kubernetes! && sleep 3600
## |     State:          Waiting
## |       Reason:       CreateContainerConfigError
## |     Ready:          False
## |     Restart Count:  0
## |     Environment:    <none>
## |     Mounts:
## |       /var/run/secrets/kubernetes.io/serviceaccount from default-token-f6npk (ro)
## | Conditions:
## |   Type           Status
## |   Initialized    True 
## |   Ready          False 
## |   PodScheduled   True 
## | Volumes:
## |   default-token-f6npk:
## |     Type:        Secret (a volume populated by a Secret)
## |     SecretName:  default-token-f6npk
## |     Optional:    false
## | QoS Class:       BestEffort
## | Node-Selectors:  <none>
## | Tolerations:     <none>
## | Events:
## |   Type     Reason                 Age              From               Message
## |   ----     ------                 ----             ----               -------
## |   Normal   Scheduled              2m               default-scheduler  Successfully assigned myapp-pod to minikube
## |   Normal   SuccessfulMountVolume  2m               kubelet, minikube  MountVolume.SetUp succeeded for volume "default-token-f6npk"
## |   Normal   Pulling                2m               kubelet, minikube  pulling image "node:alpine"
## |   Normal   Pulled                 2m               kubelet, minikube  Successfully pulled image "node:alpine"
## |   Warning  Failed                 1m (x5 over 2m)  kubelet, minikube  Error: container has runAsNonRoot and image will run as root
## |   Normal   Pulled                 1m (x4 over 2m)  kubelet, minikube  Container image "node:alpine" already present on machine
## | bash-3.2$ 
## `-----------
```


- Clean up
```
kubectl delete -f ./kubernetes.yaml
```


Useful links:

https://kubernetes.io/blog/2016/08/security-best-practices-kubernetes-deployment/
