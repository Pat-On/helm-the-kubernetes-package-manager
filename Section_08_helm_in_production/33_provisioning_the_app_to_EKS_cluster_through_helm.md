# Provisioning the app to eks cluster through helm

## The weather app helm charts


```

            GO          JS          Python              MySQL
        Auth            UI          Weather             Database

        deploy         deploy       deploy              Helm
        svc             svc          svc                (dependency)
                                    secret 
                                    (api key)


```


## Pushing image to the docker hub
- login
- build image 
- push image


## mysql - generating password 
- auto-generation
- `helm upgrade --install weatherapp-auth --set mysql.auth.rootPassword=<password> .`


```
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=weatherapp-auth,app.kubernetes.io/instance=weatherapp-auth" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
```

## weatheraap-weather

- `helm upgrade --install weatherapp-weather --set apikey=<apikey> .`

```
Release "weatherapp-weather" does not exist. Installing it now.
NAME: weatherapp-weather
LAST DEPLOYED: Mon May 29 16:55:15 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=weatherapp-weather,app.kubernetes.io/instance=weatherapp-weather" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT

```

## weatherapp-ui

- `helm upgrade --install weatherapp-ui .`

```
Release "weatherapp-ui" does not exist. Installing it now.
NAME: weatherapp-ui
LAST DEPLOYED: Mon May 29 16:55:57 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
     NOTE: It may take a few minutes for the LoadBalancer IP to be available.
           You can watch the status of by running 'kubectl get --namespace default svc -w weatherapp-ui'
  export SERVICE_IP=$(kubectl get svc --namespace default weatherapp-ui --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
  echo http://$SERVICE_IP:80

```

## Tutor forgot to mention that you just need to authorize and change context of kubectl of AWS cli tool

Remember to remove persistent HDD / SSD

- `kubectl get pvc`