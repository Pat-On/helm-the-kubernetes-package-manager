# 6 Upgrading and deleting Helm charts

helm list 

helm list --all-namespaces

```
NAME      	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART       APP VERSION
my-release	default  	1       	2023-05-23 08:48:32.14112969 +0100 BST 	deployed	nginx-14.2.21.24.0     
nginx01   	web      	1       	2023-05-23 09:02:05.323500037 +0100 BST	deployed	nginx-14.2.21.24.0     
nginx02   	default  	1       	2023-05-25 05:52:30.515644269 +0100 BST	deployed	nginx-12.0.11.22.0     
nginx03   	default  	1       	2023-05-25 05:59:57.174626028 +0100 BST	deployed	nginx-14.2.21.24.0 
```

kubectl get svc

```
NAME               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes         ClusterIP      10.96.0.1        <none>        443/TCP        4d11h
my-release-nginx   LoadBalancer   10.97.127.98     localhost     80:32479/TCP   2d21h
nginx02            LoadBalancer   10.110.109.214   <pending>     80:31915/TCP   24h
nginx03            NodePort       10.97.222.124    <none>        80:30364/TCP   23h
```
## we can upgrade the instances of the installation
changing to nodeport and to the different port now


helm upgrade nginx01 --set service.type=NodePort --set service.port=8080 bitnami/nginx


output from the console:
```
    export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services nginx02)
    export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
    echo "http://${NODE_IP}:${NODE_PORT}"

```

NAME               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes         ClusterIP      10.96.0.1        <none>        443/TCP        4d11h
my-release-nginx   LoadBalancer   10.97.127.98     localhost     80:32479/TCP   2d21h
nginx02            NodePort       10.110.109.214   <none>        80:31915/TCP   24h
nginx03            NodePort       10.97.222.124    <none>        80:30364/TCP   24h


helm upgrade nginx01 --values values.yaml bitnami/nginx


helm list 

helm upgrade nginx01 --version 9.3.5 --values.yaml bitnami/nginx

## we can use command bellow to be sure that all modified values are going to stay the same `--reuse-values`
```
helm upgrade nginx01 --version 9.3.5 --reuse-values bitnami/nginx
```

## you can uninstall chart intalation very easily

```
helm uninstall nginx
```

this command does not require yaml files

uninstalling the nginx in the different namespace

```
helm uninstall nginx02 -n default
```

