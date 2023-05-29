# 24 Creating your own Helm repository

- https://charts.bitnami.com/bitnami/index.yaml
- charts can be deployed to different places like s3 bucket etc


## Helm chart repository - structure
1. one or more Helm charts
2. and index.yaml file that contains data related to the charts
3. a web server to host them


## steps
- `mkdir ../myrepo`
- `helm package --destination ../myrepo .`
- `helm repo index ../myrepo`

## testing
- `sudo docker run -d -p 80:80 -v $(pwd):/usr/local/apache2/htdocs httpd`
- `helm repo add myrepo http://localhost`
- `helm search repo "myapp"`
- `helm install  myapp01 myrepo/myapp --set apikey="<apikey>"`


## providing different versions of the package
- `helm package --destination ../myrepo/ .`
- `helm repo index ../myrepo/`
- `helm repo update`
- `helm search repo "myapp" --versions`