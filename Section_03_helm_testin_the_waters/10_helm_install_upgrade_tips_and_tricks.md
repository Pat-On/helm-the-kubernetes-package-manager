# tips amd tricks

## Tip1: auto-generate release name

`helm install nginx01 bitnami/nginx`

helm is going to use nginx01 name to define all necessary services

Creating random string

`export RELEASE_SUFFIX=$(tr -dc a-z0-9 </dev/urandom | head -c 13 ; echo)`

then you can use this:

`helm install nginx-$RELEASE_SUFFIX bitnami/nginx`

## helm has already flag that can help us save that extra step

`helm install bitnami/nginx --generate-name`

---


## Tip2: Auto generate the namespace

in case that we are deploying our helm somewhere where we do not have the namespace created yet


`helm install nginx01 -n apps bitnami/nginx --create-namespace`

The namespace is going to be created but helm is defining namespace

Uninstalling the deployment would not remove the namespace

## Tips 3: install the release or upgrade it

helm in CI/CD

`helm upgrade --install nginx01 --set service.port=8080 bitnami/nginx`



## Tip 4: verify that the application is running

helm can fail deployment because helm as a default is only validating if k8s accepted yaml but we can change it by usdinmg this flags:  `--wait`

```
helm upgrade nginx01 --set image.registry=foobar bitnami/nginx --wait --timeout 10s
```

