# Test helm releases using dry run

## helm testing the waters xD

- Test helm releases using dry-run
- inspect a helm chart
- visit helm release history
- advances installation and upgrade

---

## `dry-run`

how does helm work with charts?
- helm looking for chart that you want to install
    -  helm is taking this file from local disk or remote repository

- parse the values of yaml file and any values that you passed via command line through the set flag

- outcome of steps descibed above are files that kubernetess understand like:
  - deploy 
  - svc
  - ing
  - etc

- files are send to the k8s in the same way that us done with the kubectl command
- THIS IS PLACE WHERE `--DRY-RUN` IS TAKING PLACE
- SO AT THIS STAGE WE WOULD NOT SEND IT TO THE K8S TO APPLY THEM
- WE ARE GOING TO GET THEM BACK

EXAMPLE

```
helm install nginx03 --values values.yaml --set service.port=8080 bitnami/nginx
```

```
helm install nginx03 --values values.yaml --set service.port=8080 --dry-run bitnami/nginx
```
ouput:
```
NAME: nginx03
LAST DEPLOYED: Fri May 26 07:08:34 2023
NAMESPACE: default
STATUS: pending-install
REVISION: 1
TEST SUITE: None
HOOKS:
MANIFEST:
---
# Source: nginx/templates/svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx03
  namespace: "default"
  labels:
    app.kubernetes.io/name: nginx
    helm.sh/chart: nginx-14.2.2
    app.kubernetes.io/instance: nginx03
    app.kubernetes.io/managed-by: Helm
  annotations:
spec:
  type: NodePort
  sessionAffinity: None
  externalTrafficPolicy: "Cluster"
  ports:
    - name: http
      port: 80
      targetPort: http
  selector:
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: nginx03
---
# Source: nginx/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx03
  namespace: "default"
  labels:
    app.kubernetes.io/name: nginx
    helm.sh/chart: nginx-14.2.2
    app.kubernetes.io/instance: nginx03
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  strategy:
    rollingUpdate: {}
    type: RollingUpdate
  selector:
    matchLabels:
      app.kubernetes.io/name: nginx
      app.kubernetes.io/instance: nginx03
  template:
    metadata:
      labels:
        app.kubernetes.io/name: nginx
        helm.sh/chart: nginx-14.2.2
        app.kubernetes.io/instance: nginx03
        app.kubernetes.io/managed-by: Helm
      annotations:
    spec:
      
      automountServiceAccountToken: false
      shareProcessNamespace: false
      serviceAccountName: default
      affinity:
        podAffinity:
          
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - podAffinityTerm:
                labelSelector:
                  matchLabels:
                    app.kubernetes.io/name: nginx
                    app.kubernetes.io/instance: nginx03
                topologyKey: kubernetes.io/hostname
              weight: 1
        nodeAffinity:
          
      hostNetwork: false
      hostIPC: false
      initContainers:
      containers:
        - name: nginx
          image: docker.io/bitnami/nginx:1.24.0-debian-11-r10
          imagePullPolicy: "IfNotPresent"
          env:
            - name: BITNAMI_DEBUG
              value: "false"
            - name: NGINX_HTTP_PORT_NUMBER
              value: "8080"
          envFrom:
          ports:
            - name: http
              containerPort: 8080
          livenessProbe:
            failureThreshold: 6
            initialDelaySeconds: 30
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 5
            tcpSocket:
              port: http
          readinessProbe:
            failureThreshold: 3
            initialDelaySeconds: 5
            periodSeconds: 5
            successThreshold: 1
            timeoutSeconds: 3
            tcpSocket:
              port: http
          resources:
            limits: {}
            requests: {}
          volumeMounts:
      volumes:

NOTES:
CHART NAME: nginx
CHART VERSION: 14.2.2
APP VERSION: 1.24.0
```

it is yaml file that is contain all changes that are going to be implemented into our deployments

