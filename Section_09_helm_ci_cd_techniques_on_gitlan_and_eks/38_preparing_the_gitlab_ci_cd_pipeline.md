# 38 Setting up a CI/CD pipeline in GitLab

- Setting AWS_ACCESS_KEY_ID
  - access key of our gitlab user
- AWS_SECRET_ACCESS_KEY
  - secret access key of our user


## refer to video 35

## ENV 
- API_KEY
- CI_REGISTRY_PASSWORD
- CI_REGISTRY_USER
- DB_PASSWORD
- K8SCONFIG

## CI/CD pipeline workflow
- the main branch contains the latest code version
- commits should not be pushed directly to the main branch
- instead a branch is created to host code changes. then an MR is made to merge with main
- when code is pushed to the branch the pipeline is triggered to validate the code
- when the mr is approved the code is merged to main. The pipeline is invoked again to build and push docker images to the repository
- latest code is delivered to the staging environment automatically
- shipping to production is blocked until it is manually approved for security and business reasons
- 
