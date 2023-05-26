Link: https://charts.bitnami.com/


```
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search repo bitnami
$ helm install my-release bitnami/<chart>
```

`helm repo list`

```
NAME    URL                               
bitnami https://charts.bitnami.com/bitnami
```


`helm search repo nginx`
```
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                                       
bitnami/nginx                           14.2.2          1.24.0          NGINX Open Source is a web server that can be a...
bitnami/nginx-ingress-controller        9.7.1           1.7.1           NGINX Ingress Controller is an Ingress controll...
bitnami/nginx-intel                     2.1.15          0.4.9           DEPRECATED NGINX Open Source for Intel is a lig...
```

`helm search repo --versions nginx`


## installing and checking kubectl context
- your helm is using the same context that you are using in your kubectl
- `kubectl config get-contexts`

```
CURRENT   NAME             CLUSTER          AUTHINFO         NAMESPACE
*         docker-desktop   docker-desktop   docker-desktop   
```


kubectl create ns web

kubectl config set-context --current --namespace web

helm install nginx01 bitnami/nginx

```
NAME: nginx01
LAST DEPLOYED: Tue May 23 09:02:05 2023
NAMESPACE: web
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: nginx
CHART VERSION: 14.2.2
APP VERSION: 1.24.0

** Please be patient while the chart is being deployed **
NGINX can be accessed through the following DNS name from within your cluster:

    nginx01.web.svc.cluster.local (port 80)

To access NGINX from outside the cluster, follow the steps below:

1. Get the NGINX URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace web -w nginx01'

    export SERVICE_PORT=$(kubectl get --namespace web -o jsonpath="{.spec.ports[0].port}" services nginx01)
    export SERVICE_IP=$(kubectl get svc --namespace web nginx01 -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    echo "http://${SERVICE_IP}:${SERVICE_PORT}"

```

kubectl get svc nginx01


```
kubectl get all
NAME                          READY   STATUS    RESTARTS   AGE
pod/nginx01-654dd8864-vhdqd   1/1     Running   0          114s

NAME              TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/nginx01   LoadBalancer   10.107.117.162   <pending>     80:31381/TCP   114s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx01   1/1     1            1           114s

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx01-654dd8864   1         1         1       114s
pat@pat-GE62-2QF:~/Projects/helm-the-kubernetes-package-manager/Section_2_exploring_helm's_ngionx_chart$ kubectl get -A
You must specify the type of resource to get. Use "kubectl api-resources" for a complete list of supported resources.

error: Required resource not specified.
Use "kubectl explain <resource>" for a detailed description of that resource (e.g. kubectl explain pods).
See 'kubectl get -h' for help and examples
pat@pat-GE62-2QF:~/Projects/helm-the-kubernetes-package-manager/Section_2_exploring_helm's_ngionx_chart$ kubectl get all -A
NAMESPACE     NAME                                         READY   STATUS    RESTARTS       AGE
default       pod/my-release-nginx-599d654c74-2gvwv        1/1     Running   0              15m
kube-system   pod/coredns-565d847f94-fxvvl                 1/1     Running   2 (15m ago)    38h
kube-system   pod/coredns-565d847f94-zl8th                 1/1     Running   2 (15m ago)    38h
kube-system   pod/etcd-docker-desktop                      1/1     Running   6 (15m ago)    38h
kube-system   pod/kube-apiserver-docker-desktop            1/1     Running   6 (15m ago)    38h
kube-system   pod/kube-controller-manager-docker-desktop   1/1     Running   6 (15m ago)    38h
kube-system   pod/kube-proxy-hdxpn                         1/1     Running   2 (15m ago)    38h
kube-system   pod/kube-scheduler-docker-desktop            1/1     Running   6 (15m ago)    38h
kube-system   pod/storage-provisioner                      1/1     Running   4 (15m ago)    38h
kube-system   pod/vpnkit-controller                        1/1     Running   10 (15m ago)   38h
web           pod/nginx01-654dd8864-vhdqd                  1/1     Running   0              2m11s

NAMESPACE     NAME                       TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes         ClusterIP      10.96.0.1        <none>        443/TCP                  38h
default       service/my-release-nginx   LoadBalancer   10.97.127.98     localhost     80:32479/TCP             15m
kube-system   service/kube-dns           ClusterIP      10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP   38h
web           service/nginx01            LoadBalancer   10.107.117.162   <pending>     80:31381/TCP             2m11s

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   38h

NAMESPACE     NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
default       deployment.apps/my-release-nginx   1/1     1            1           15m
kube-system   deployment.apps/coredns            2/2     2            2           38h
web           deployment.apps/nginx01            1/1     1            1           2m11s

NAMESPACE     NAME                                          DESIRED   CURRENT   READY   AGE
default       replicaset.apps/my-release-nginx-599d654c74   1         1         1       15m
kube-system   replicaset.apps/coredns-565d847f94            2         2         2       38h
web           replicaset.apps/nginx01-654dd8864             1         1         1       2m11s
```~~~~