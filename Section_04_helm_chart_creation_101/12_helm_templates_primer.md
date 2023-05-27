# Helm Templates primer

## Recap - was in previous lecture
`helm install nginx03 --values value.yaml --set service.port=8080 bitnami/nginx`

### how helm is setting this all up - service.yaml

- this service.yaml is responsible to generate the service yaml files

- this file looks almost exactly the same like the kubernetes yaml file. The oly difference is this file has the line that has to be executed


### Basic Helm template rules
- anything between {{ and }} is rendered.
  - for example {{ lower "Hello" }} is rendered as hello
- You can get a value using the `.Values` keyword followed by property. For examples, `.Values.service.port`.
- The include function embeds another template. The second argument specified the variable scope for the embedded template. We often use (.) to indicate root.
- Helm functions accept parameters on the same line separated by spaces (no brackets or commas)



```
apiVersion: v1
kind: Service
metadata:
  # this of it is as include(myapp.fullname, .) in other programming languages
  name: {{ include "myapp.fullname" . }} #
  labels:
    {{- include "myapp.labels" . | nindent 4 }} # indent is making sure that yaml file are correctly intended
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "myapp.selectorLabels" . | nindent 4 }}
```

- `include` is the function that is used by helm



## `_helpers.tpl` 
- helm  is not rendering this file
- it is used to define mini templates that can be embedded in the other templates
- `|` - this works the same way like in the linux
  - example: `{{- .Release.Name | trunc 63 | trimSuffix "-" }}`
- `-` at the front remove all white spaces before generated output
- `-` at the end it removes white spaces after the output


## lets have a dry run 
`helm install myapp02 --dry-run .`

Output:
```
NAME: myapp02
LAST DEPLOYED: Sat May 27 06:59:47 2023
NAMESPACE: default
STATUS: pending-install
REVISION: 1
HOOKS:
---
# Source: myapp/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "myapp02-test-connection"
  labels:
    helm.sh/chart: myapp-0.1.0
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: myapp02
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['myapp02:80']
  restartPolicy: Never
MANIFEST:
---
# Source: myapp/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: myapp02
  labels:
    helm.sh/chart: myapp-0.1.0
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: myapp02
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
---
# Source: myapp/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp02
  labels:
    helm.sh/chart: myapp-0.1.0
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: myapp02
    app.kubernetes.io/version: "1.0.0"
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
    app.kubernetes.io/instance: myapp02
---
# Source: myapp/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp02
  labels:
    helm.sh/chart: myapp-0.1.0
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: myapp02
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: myapp
      app.kubernetes.io/instance: myapp02
  template:
    metadata:
      labels:
        app.kubernetes.io/name: myapp
        app.kubernetes.io/instance: myapp02
    spec:
      serviceAccountName: myapp02
      securityContext:
        {}
      containers:
        - name: myapp
          securityContext:
            {}
          image: "nginx:1.0.0"
          imagePullPolicy: IfNotPresent
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
            {}

NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=myapp,app.kubernetes.io/instance=myapp02" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
```