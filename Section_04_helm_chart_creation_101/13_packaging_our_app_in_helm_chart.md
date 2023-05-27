# Packaging our app in a Helm chart

- main goal of helm is packaging the k8s application that it can be very easy install, updated, uninstalled

## customization to deploy our app

`sudo docker run -d -p 8080:80 afakharany/hellonodejs:1.0.0`

 

## Where helm define the image of the application: `deployment.yaml` file

`image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"`

- important note: we have default values in the helm, so we can define them in the way that they are going to be overwritten

### deleting all docker containers from the previous lessons + helm deployments

- docker:
  - docker ps
  - docker kill <hash>
- helm
  - helm list
  - helm uninstall <app_name>

### Installing our modified application

`helm install myapp01 .`

`kubectl port-forward myapp01-5f79fb647b-m7pzs 8080:80`

- we can use port forwarding because we are using `ClusterIP` service

### we can create helm packages by running a simple command

- `helm package .`
- `.helmignore` - the same purpose like `.gitignore`
- you do not have to even uncompressed this tgr files