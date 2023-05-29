# 26 Hosting your Helm repo using Chartmuseum

## Drawbacks of using our own web server as a Helm repo
- hosted files are manually managed
- the index.yaml file needs to be maintained after each update
- hard to integrate with cloud storage
- user authentication and TLS adds even more complexity
- maintaining the solution on the long run


## Chartmuseum 
- Open-source project written in go and part of CNCF
- Provides an api interface for managing charts
- can be deployed as a standalone binary, docker container or a Helm chart
- the index.yaml is automatically managed
- can integrate with several storage options:
  - local filesystem
  - aws s3
  - google cloud storage
  - Azure blob storage
  - alibaba cloud oss storage
  - openstack object storage


```
                                          ----------> Local Storage (charts)
        username/password               /
client --------------------> Chart Museum 
        HTTPS                           \
                                          ----------> S3 Bucker (charts)

```

