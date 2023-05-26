# Inspect a Helm release
```
helm get notes nginx01
```

```
x01
NOTES:
CHART NAME: nginx
CHART VERSION: 14.2.2
APP VERSION: 1.24.0

** Please be patient while the chart is being deployed **
NGINX can be accessed through the following DNS name from within your cluster:

    nginx01.default.svc.cluster.local (port 80)

To access NGINX from outside the cluster, follow the steps below:

1. Get the NGINX URL by running these commands:

    export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services nginx01)
    export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
    echo "http://${NODE_IP}:${NODE_PORT}"
```


```
helm get values nginx01
```

```
nx01
USER-SUPPLIED VALUES:
service:
  port: 8080
  type: NodePort
```
This command will ony provide information supplied bt the user


### all information that are as well default values

```
helm get values nginx01 --all
```

we are going to get here everything


---

### to check what definition files where used to deploy current resources

`helm get manifest`

similar to the `--dry-run` the only different is that manifest was deployed where `--dry-run` was not

