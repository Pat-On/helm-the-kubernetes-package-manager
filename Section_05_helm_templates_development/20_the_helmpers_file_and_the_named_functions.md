# 19 the _helpers file and named templates

- help template is not rendered by helm
- we cannot use them to render any resources
- we use them to encapsulate complex logic that is needed in multiple places of our chart
- something like global functions that can be called anywhere in the chart


## naming the helpers based on the example from _helpers.tpl
```
{{- define "myapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
```


## changing the name and the output of NOTES.txt file

```
{{ include "myapp.name" . }}
```

output:
```
myapp
```


terminal: 
`helm upgrade myapp01 ./myapp --set apikey="ae6a4f5951msh27a3df229133f1ap18170fjsn98b2735c6782" --set nameOverride=awesome --dry-run`

output: `awesome`

# Create a default fully qualified app name - chart 
it is going to be used to provide names for application and difference services and prevent any naming collisions

```
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "myapp.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}
```

```
helm upgrade myapp01 ./myapp --set apikey="ae6a4f5951msh27a3df229133f1ap18170fjsn98b2735c6782" --set fullnameOverride=awesome --dry-run
```

# why we need to know about the service account name created by the helm?
- because of the permissions scope and other assignment functionalities
- service accounts should be correctly identify and manage because of the security
- kubernetes created automatically service account that is default


------


# interesting fact about how and when the images are pulled by kubernetes and where stored! 

```
Image pull policy
The imagePullPolicy for a container and the tag of the image affect when the kublet attempts to pull (download) the specified image.

Here's a list of the values you can set for imagePullPolicy and the effects these values have:

IfNotPresent
the image is pulled only if it is not already present locally.
Always
every time the kubelet launches a container, the kubelet queries the container image registry to resolve the name to an image digest. If the kubelet has a container image with that exact digest cached locally, the kubelet uses its cached image; otherwise, the kubelet pulls the image with the resolved digest, and uses that image to launch the container.
Never
the kubelet does not try fetching the image. If the image is somehow already present locally, the kubelet attempts to start the container; otherwise, startup fails. See pre-pulled images for more details.
The caching semantics of the underlying image provider make even imagePullPolicy: Always efficient, as long as the registry is reliably accessible. Your container runtime can notice that the image layers already exist on the node so that they don't need to be downloaded again.
```
https://kubernetes.io/docs/concepts/containers/images/
https://kubernetes.io/docs/concepts/containers/images/#pre-pulled-images

Important:
in the production you should set-up pull policy always to authenticate because if the node has the image already downloaded all containers have access to it. what about speed?
