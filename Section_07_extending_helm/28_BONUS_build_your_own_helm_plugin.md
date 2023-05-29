# Build your own Helm Plugin

## What makes up a Helm plugin?

- A file called plugin.yaml
- Optionally: a script or program to execute



- https://helm.sh/docs/topics/plugins/
  
```
name: "last"
version: "0.1.0"
usage: "get the last release name"
description: "get the last release name"
ignoreFlags: false
command: "$HELM_BIN --host $TILLER_HOST list --short --max 1 --date -r"
platformCommand:
  - os: linux
    arch: i386
    command: "$HELM_BIN list --short --max 1 --date -r"
  - os: linux
    arch: amd64
    command: "$HELM_BIN list --short --max 1 --date -r"
  - os: windows
    arch: amd64
    command: "$HELM_BIN list --short --max 1 --date -r"
```


## Environment Variables (source - helm docs)
When Helm executes a plugin, it passes the outer environment to the plugin, and also injects some additional environment variables.

Variables like KUBECONFIG are set for the plugin if they are set in the outer environment.

The following variables are guaranteed to be set:

- HELM_PLUGINS: The path to the plugins directory.
- HELM_PLUGIN_NAME: The name of the plugin, as invoked by helm. So helm myplug will have the short name myplug.
- HELM_PLUGIN_DIR: The directory that contains the plugin.
- HELM_BIN: The path to the helm command (as executed by the user).
- HELM_DEBUG: Indicates if the debug flag was set by helm.
- HELM_REGISTRY_CONFIG: The location for the registry configuration (if using). Note that the use of Helm with registries is an experimental feature.
- HELM_REPOSITORY_CACHE: The path to the repository cache files.
- HELM_REPOSITORY_CONFIG: The path to the repository configuration file.
- HELM_NAMESPACE: The namespace given to the helm command (generally using the -n flag).
- HELM_KUBECONTEXT: The name of the Kubernetes config context given to the helm command.


## check the file in the myplugin/plugin.yaml

- `helm plugin install .`
- global instalation
- `helm plugin list` 

```
NAME     	VERSION	DESCRIPTION                       
dashboard	1.3.1  	View HELM situation in nice web UI
last     	0.1.0  	get the last release name  
```


## The helm SCP plugin
- packages and uploads a helm chart to a remote server over ssh using secure copy (SCP)
- it is requires the following parameters:
  - -I the path to the chart directory
  - -u the usrname used to login to the remote server over ssh
  - -s the ip address or the hostname of the remote server
  - -k the ssh key used to login to the remote server (default to ~/.ssh/id_rsa)
  - -p the ssh port default 22
  - -r the remote path to store the packaged chart file


https://github.com/abohmeed/helmscpplugin