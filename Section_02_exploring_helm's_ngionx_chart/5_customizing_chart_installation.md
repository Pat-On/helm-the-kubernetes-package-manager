# Customizing char installation

```
NAME                                    READY   STATUS    RESTARTS   AGE
pod/my-release-nginx-599d654c74-2gvwv   1/1     Running   0          44h

NAME                       TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/kubernetes         ClusterIP      10.96.0.1      <none>        443/TCP        3d11h
service/my-release-nginx   LoadBalancer   10.97.127.98   localhost     80:32479/TCP   44h

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/my-release-nginx   1/1     1            1           44h

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/my-release-nginx-599d654c74   1         1         1       44h
```

`helm search repo --versions "nginx server"`


kubectl config get-contexts

helm install nginx02 --version 12.0.1 -n default bitnami/nginx

kubectl get pods -n default
```
NAME                                READY   STATUS    RESTARTS        AGE
my-release-nginx-599d654c74-2gvwv   1/1     Running   1 (6m36s ago)   45h
nginx02-7bf67b595c-m7s2s            1/1     Running   0               24s
```

kubectl -n default exec -it nginx02-7bf67b595c-m7s2s bash


NOTE: many decision was made by helm for example open ports, loadbalancer

examples: (service is type of the load balancer)
```
ubectl get svc -n default
NAME               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes         ClusterIP      10.96.0.1        <none>        443/TCP        3d11h
my-release-nginx   LoadBalancer   10.97.127.98     localhost     80:32479/TCP   45h
nginx02            LoadBalancer   10.110.109.214   <pending>     80:31915/TCP   3m47s
```

## modifying parameters in char
helm install nginx03 --values values.yaml --set service.port=8080 bitnami/nginx


```
kubectl get svc nginx03
NAME      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx03   NodePort   10.97.222.124   <none>        80:30364/TCP   15s
```


## Helm char values hierarchy
```
parent chart values         <----service.port: 80 - shadowed
        |
        |
        |       Overridden by
        |
        V
Sub Chart Values            <---- service.port 8888 - shadowed
        |
        |
        |       Overridden by 
        |
        V
--set command line flag     <---- service.port 8080 - applied
```