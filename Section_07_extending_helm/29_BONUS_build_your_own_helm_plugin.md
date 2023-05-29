# Using Downloader plugins to support custom protocols

## How helm uses repositories







```

                        http / https + basic authentication
HELM    ------------------------------------------------------------->  SERVER
                            /index.yaml
        <------------------------------------------------------------
                            /chart-0.x.y.tgz
        <------------------------------------------------------------



                custom AWS authentication
                aws-specific commands for pulling and pushing objects
        ------------------------------------------------------------>       AWS S3



                JWT Bearer token authentication
        ------------------------------------------------------------>       API

    

### You need to use downloaders
- to support protocolos in helm that are not standard you need to add to the helm 
- downloaders that are going to be used in the case that helm is going to be tasks to download something from somewhere without using known by it protocol.

### hooks - such a common concept! 