# The .Files method group 

- all kubernetes application needs configuration and the helm it is not making it different
  - ports to listen
  - ssl 
  - and so on

In the kubernetes we have `configMaps`

- `ConfigMaps` - https://kubernetes.io/docs/concepts/configuration/configmap/
- `secret` - password api key
  

# myapp version 2.0.0
- displays current weather conditions in the required city
- contacts a public weather API to get the data
- needs an API key to be able to contact the API and get the data


## example from the docker based on the new app

- `cat default.json`
```
{
    "network": {
        "port": "80"
    },
    "environment": {
        "SSL": false
    }
}
```


- `docker run -p 8080:80 -d -e APIKEY=<API_KEY> -v $(pwd)/config/default.json:/app/config/default.json afalharany/hellonodejs:2.0.0`



`helm upgrade myapp01 ./myapp --dry-run`

```
helm upgrade myapp01 ./myapp --dry-run
Release "myapp01" has been upgraded. Happy Helming!
NAME: myapp01
LAST DEPLOYED: Sun May 28 07:00:31 2023
NAMESPACE: default
STATUS: pending-upgrade
REVISION: 2
HOOKS:
---
# Source: myapp/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "myapp01-test-connection"
  labels:
    helm.sh/chart: myapp-0.1.1
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: myapp01
    app.kubernetes.io/version: "2.0.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['myapp01:80']
  restartPolicy: Never
MANIFEST:
---
# Source: myapp/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: myapp01
  labels:
    helm.sh/chart: myapp-0.1.1
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: myapp01
    app.kubernetes.io/version: "2.0.0"
    app.kubernetes.io/managed-by: Helm
---
# Source: myapp/templates/secret.yaml
apiVersion: v1
kind: Secret
metadata: 
  name: myapp01
type: Opaque
## APIKEY is encoded too! 
data: 
  APIKEY: PEFQSV9LRVk+
---
# Source: myapp/templates/configmap.yaml
# we need to create this file by ourself
apiVersion: v1
kind: ConfigMap
metadata:
  name: myapp01
## -------------------- included default.json files -----------------------------
data:
  default.json: |
      {
        "network": {
          "port" : "80"
        },
        "environment": {
          "SSL": false 
        }
      }
---
# Source: myapp/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp01
  labels:
    helm.sh/chart: myapp-0.1.1
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: myapp01
    app.kubernetes.io/version: "2.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: myapp01
---
# Source: myapp/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp01
  labels:
    helm.sh/chart: myapp-0.1.1
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: myapp01
    app.kubernetes.io/version: "2.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: myapp
      app.kubernetes.io/instance: myapp01
  template:
    metadata:
      labels:
        app.kubernetes.io/name: myapp
        app.kubernetes.io/instance: myapp01
    spec:
      serviceAccountName: myapp01
      securityContext:
        {}
      containers:
        - name: myapp
          securityContext:
            {}
          image: "afakharany/hellonodejs:2.0.0"
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - name: config
              mountPath: /app/config/default.json
              subPath: default.json
          env:
            - name: APIKEY
              valueFrom:
                secretKeyRef:
                  name: myapp01
                  key: APIKEY
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            limits:
              cpu: 100m
              memory: 128Mi
            requests:
              cpu: 100m
              memory: 128Mi
      volumes:
        - name: config
          ConfigMap:
            name: myapp01

NOTES:
Resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi
```


# checking if everything is working:

- `kubectl get pods`
- `kubectl port-forward myapp01-3454234 8080:80`


# passing secrets via the command line
- helm upgrade myapp01 ./myapp --set apikey="<api_key>"


# bash

```
for f in {1..5}
do
    touch $f.json && echo \{\"name\":\"File $f\"\} > $f.json
done


```

&& echo \{"name\":\"File $f\"\} > $f.json

# side note from me:
debbuging crashin application because of the spelling mistake in the yaml file of helm

commands:
- `kubectl describe pods myapp01-f687fb4d8-2wpb8`
  - is going to provide you insides about the pod what is going inside of it

- in my case the problem was that I wrote ConfigMap should be configMap. It could not mount the volume and entire app crashed
