# Setting up a CI/CD user for EKS and non-EKS Kubernetes cluster


## EKS vs non-EKS clusters user access
- EKS cluster grant access to users based on AWS IAM accounts
- They use AWS CLI command to acquire an access token for user access 
- non-eks clusters use the kubeconfig file to grant access
- Non-eks clusters could be created through kops, Terraform or other tools
- They require generating a certificate signing request, approving it from the API server so that the user can have access
- EKS clusters still require a kubeconfig but not for access granting



## What we need to do:
- openssl genrsa -out gitlab.key 2048
- openssl req -new -key gitlab.key -out gitlab.csr

Creating K8s object
- vim gitlab-csr.yaml
```
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
    name: gitlab
spec:
    request: <certificate>
    signerName: kubernetes.io/kube-apiserver-client
    usages:
        - client auth
```

- cat gitlab.csr | base64 | tr -d '\n'

then we apply the file against the cluster using:
- kubectl apply -f gitlab-csr.yaml

to check it out:
- kubectl get csr

Approving certificate
- kubectl certificate approve gitlab

Downloading certificate
- kubectl get csr gitlab -o jsonpath='{.status.certificate}' | base64 -d > gitlab.crt

- gitlab.crt contain the decoded user certificate in plain text



## Generating kubeconfig file for our user

getting certificate authority
- kubectl config view -o jsonpath='{.cluster[0].cluster.certificate-authority-data}' --raw | base64 --decode > k8s-ca.crt


## creating kubeconfig file for gitlab user adding the data that we generate till now
- kubectl config set-cluster $(kubectl config view -o jsonpath='{.cluster[0].name}')
        --server=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')
        --certificate-authority=k8s-ca,crt
        --kubeconfig=gitlab-config
        --embed-certs

## create cluster users:

- kubectl config set-credentials gitlab --client-certificate=gitlab.crt
                --client-key=gitlab.key
                --embed-certs
                --kubeconfig=gitlab-config

## creating context that it is going to be used
- kubectl config set-context gitlab --cluster=$(kubectl config view -o jsonpath='{.clusters[0].name}')
            --namespace=staging
            --user=gitlab
            --kubeconfig=gitlab-config

- kubectl config use-context gitlab --kubeconfig=gitlab-config

## Final results
- we are going to have the file that can be used by our pipelines that has all necessary information needed to accessing the cluster
- name of the file: `gitlab-config`


# Assigning permissions - main goal

- kubectl create namespace staging
- kubectl create role cicd --verb="*" --resource="*" --namespace staging
- kubectl edit role cicd -n staging


## creating role binding and attaching it to our role
- kubectl create rolebinding cicd --role cicd --user=gitlab -N STAGING

for default space:
- kubectl create role cicd --verb="*" --resource="*"
- kubectl edit role cicd 
- kubectl create rolebinding cicd --role cicd --user=gitlab 


# testing if everything is working
- kubectl get pods -n staging --kubeconfig gitlab-config 
- kubectl get pods -n default --kubeconfig gitlab-config
- kubectl get pods -n kube-system --kubeconfig gitlab-config


-----

- kops delete cluster --yes


- eksctl create cluster -f cluster.yaml


## creating the iam user
- aws iam create-user --user-name gitlab

## generating access key for this user
- aws iam create-access-key --user-name gitlab 


##  getting the AWS identity
- aws sts get-caller-identity

## informing EKS about our user that it can access cluster
- kubectl edit cm/aws-auth -n kube-system
  - adding mapUsers! WOW! nice


## creating namespace for k8s
- kubectl create namespace staging


## creating the role
- kubectl create role cicd --verb="*" --resource="*" --namespace staging

-kubectl edit rol cicd -n staging

## creating role binding
- kubectl create rolebinding cicd --role cicd --user=gitlab -n staging

### replicating this steps for the default namespace that is going to be used as a production
- kubectl create role cicd --verb="*" --resource="*" 
- kubectl edit rol cicd
- kubectl create rolebinding cicd --role cicd --user=gitlab

# Testing the setup
- aws configure --profile gitlab

- export AWS_PROFILE=gitlab
- kubectl get pods -n staging
- kubectl get pods


