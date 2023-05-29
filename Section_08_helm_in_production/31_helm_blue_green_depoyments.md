# Blue/Green Deployments using helm
## Advanced app-provisioning mechanisms

- to switch between use: this command
  - `helm upgrade bluegreen --set "currentTarget.app=green" .`
  - `helm upgrade bluegreen --set "currentTarget.app=blue" .`
