# 09 helm history and rollback

helm list 

helm get values nginx01


## testing release history
We are going to provide wrong config to the commands

```
helm upgrade nginx01 --dry-run --set service.type=foobar bitnami/nginx
```

of course k8s rejected this because there is no service called foobar :>


## Helm releases statuses

- `pending-install` - the manifests are ready but they were not sent to k8s yet
- `deployed` - the manifests were sent to Kubernetes and they were accepted
- `pending-upgrade` = the upgraded manifests are ready but were not sent to k8s yet
- `superseded` when a release is upgraded successfully
- `pending-rollback` - when roll-back manifests are generated but they were not sent to k8s yet
- `uninstalling` when the current most recent release is being uninstalled
- `uninstalled` if history is retained the status of the last uninstalled release
- `failed` if kubernetes rejects the manifests supplied by helm  during any operations
 
---

helm list

output:
```
NAME   	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART       	APP VERSION
nginx01	default  	2       	2023-05-26 07:22:29.887881181 +0100 BST	failed  	nginx-14.2.2	1.24.0     
nginx03	default  	1       	2023-05-26 07:07:42.545213203 +0100 BST	deployed	nginx-14.2.2	1.24.0
```


to check the most recent deploy you need to check

helm history nginx01

```
REVISION	UPDATED                 	STATUS  	CHART       	APP VERSION	DESCRIPTION                                                                                                                                                                                                        
1       	Fri May 26 07:11:20 2023	deployed	nginx-14.2.2	1.24.0     	Install complete                                                                                                                                                                                                   
2       	Fri May 26 07:22:29 2023	failed  	nginx-14.2.2	1.24.0     	Upgrade "nginx01" failed: cannot patch "nginx01" with kind Service: Service "nginx01" is invalid: spec.type: Unsupported value: "foobar": supported values: "ClusterIP", "ExternalName", "LoadBalancer", "NodePort"
```

## we have to ways to fix it - rollback it or just go for new deployment

`helm rollback nginx01 1`


output from `helm history nginx01`

```
REVISION	UPDATED                 	STATUS    	CHART       	APP VERSION	DESCRIPTION                                                                                                                                                                                                        
1       	Fri May 26 07:11:20 2023	superseded	nginx-14.2.2	1.24.0     	Install complete                                                                                                                                                                                                   
2       	Fri May 26 07:22:29 2023	failed    	nginx-14.2.2	1.24.0     	Upgrade "nginx01" failed: cannot patch "nginx01" with kind Service: Service "nginx01" is invalid: spec.type: Unsupported value: "foobar": supported values: "ClusterIP", "ExternalName", "LoadBalancer", "NodePort"
3       	Fri May 26 07:29:44 2023	deployed  	nginx-14.2.2	1.24.0     	Rollback to 1 
```


## lets checkout uninstalling with a keeping history releases
- we can even rolback uninstalling

`helm uninstalling nginx01 --keep-history`

and then for example using this command we are going to install it again

`helm rollback nginx01 3`


## lets deploy something that is not validated like non existing image registry

`helm upgrade nginx01 --set image.registry=foobar bitnami/nginx`

interesting - helm - did not notice that everything failed, because k8s can not download the image 

`helm history nginx01`

```
REVISION	UPDATED                 	STATUS    	CHART       	APP VERSION	DESCRIPTION                                                                                                                                                                                                        
1       	Fri May 26 07:11:20 2023	superseded	nginx-14.2.2	1.24.0     	Install complete                                                                                                                                                                                                   
2       	Fri May 26 07:22:29 2023	failed    	nginx-14.2.2	1.24.0     	Upgrade "nginx01" failed: cannot patch "nginx01" with kind Service: Service "nginx01" is invalid: spec.type: Unsupported value: "foobar": supported values: "ClusterIP", "ExternalName", "LoadBalancer", "NodePort"
3       	Fri May 26 07:29:44 2023	superseded	nginx-14.2.2	1.24.0     	Rollback to 1                                                                                                                                                                                                      
4       	Fri May 26 07:33:25 2023	deployed  	nginx-14.2.2	1.24.0     	Upgrade complete
```

## kubectl get pods

```
NAME                       READY   STATUS         RESTARTS   AGE
nginx01-654dd8864-jhnvn    1/1     Running        0          25m
nginx01-d48fbd685-xh75m    0/1     ErrImagePull   0          8s
nginx03-67c6645968-4wjkx   1/1     Running        0          28m
```
