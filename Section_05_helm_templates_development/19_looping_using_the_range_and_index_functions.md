# Looping using range and index

## settings port in the `values.yaml` file and using them in the `service.yaml`

values.yaml
```
service:
  type: ClusterIP
  port: 80
  ssl_port: 443
  ssl_target_port: 443
  ssl_name: https
```

service.yaml
```
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
      # added a new port from values.yaml
      - port: {{ .Values.service.ssl_port }}
        targatPort: {{ .Values.service.ssl_target_port }}
        name: {{ .Values.service.ssl_name }}
```

- drawbacks:
  - we need to add all values to the values.yaml file and best option is to prefix it all
  - and to add new ports for example for admin on port 8080 you will have to add bunch of other values that are defining port. etc etc 
  - manual modification


## More elegant way `list` and to loop around the values and add them to service templates

```
service:
  type: ClusterIP
  ports:
    - number: 80
      targetPort: http
      name: http
    - number: 443
      targetPort: https
      name: https
```

service.yaml
```
  type: {{ .Values.service.type }}
  ports:
  {{- range .Values.service.ports }}
    - port: {{ .number }}
      protocol: TCP
      targetPort: {{ .targetPort }}
      name: {{ .name }}
  {{- end }}   
```

Important note: this `-` symbol at the end can give crazy errors that are not clear in first look

```
helm upgrade  myapp01 ./myapp --dry-run
Error: UPGRADE FAILED: YAML parse error on myapp/templates/service.yaml: error converting YAML to JSON: yaml: line 14: mapping values are not allowed in this context
```

Output:
```
Release "myapp01" has been upgraded. Happy Helming!
NAME: myapp01
LAST DEPLOYED: Sun May 28 11:36:40 2023
NAMESPACE: default
STATUS: pending-upgrade
REVISION: 4
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
      args: ['myapp01:']
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
data: 
# so this will automatically encoded
  APIKEY: YWU2YTRmNTk1MW1zaDI3YTNkZjIyOTEzM2YxYXAxODE3MGZqc245OGIyNzM1YzY3ODI=
---
# Source: myapp/templates/configmap.yaml
# we need to create this file by ourself
apiVersion: v1
kind: ConfigMap
metadata:
  name: myapp01
data:
### Solution that map to the single file
  default.json: |
    



# .Files.Glob is returning files and it is depends from us how we want to use it
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
      protocol: TCP
      targetPort: http
      name: http
    - port: 443
      protocol: TCP
      targetPort: https
      name: https
    - port: 8080
      protocol: TCP
      targetPort: 8080
      name: admin
    - port: 8008
      protocol: TCP
      targetPort: 8008
      name: ops   

    # - port: 
    #   targetPort: http
    #   protocol: TCP
    #   name: http
    #   # added a new port from values.yaml
    # - port: 
    #   targatPort: 
    #   name: 
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
              containerPort: 
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
          configMap:
            name: myapp01

NOTES:
The service type is ClusterIP
```

Conclusion: comments (yaml type comments) are going to be added to the template. 
Interesting

- `range` - it is helm function that is used to loop over list and dictionaries (map in Go)

# Recommendations

- change values in the helm chart only by changing:
  - values.yaml
  - command line
  - never touch your values


# WHAT IF WE WANT TO CHANGE THE FLAG OF THE PORT?

- `helm install myapp01 . --dry-run --set "service.port[0].number=8000"`

- all other values are overwritten, because helm is replacing entre array not just pointer index

- so we need to supply entire array! horrible

- important in my version it is throwing error
```
yapp01 ./myapp  --set "service.port[0].number=8000"  --dry-run
Error: UPGRADE FAILED: template: myapp/templates/secret.yaml:9:32: executing "myapp/templates/secret.yaml" at <b64enc>: invalid value; expected string

```

# how to refer to only single element in the array


   
- `mainPort: {{ index .Values.service.ports 0 }}`
- `mainPort: {{ (index .Values.service.ports 0).number }}` <--- dot notation


# using helm variables:

- `{{- $ports := .Values.service.ports -}}`


# unpacking in the helm

```
  {{- range $key, $value := $ports }}
    - port: {{ .number }}
      protocol: TCP
      targetPort: {{ .targetPort }}
      name: {{ .name }}
  {{- end }}   
```