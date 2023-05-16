# Application_on_EKS

## Description
- Create a simple infrastructure on aws to make secure cluster eks wit worker nodes in different availability zones using terraform.
- Containerize jenkins app and push it to ECR.
- Deploy and Configure Jenkins on EKS.
- Deploy python app application on EKS cluster using nginx ingress controller and CI/CD jenkins pipeline.


## Tools
- AWS
- Terraform
- Ansible
- Docker 
- Kubernetes
- Scripting 
- Jenkins


## Infrastructure
- Required infrastructure to make EKS Cluster is vpc with 4 subnets; 2 public subnets and 2 private subnets, internet gateway, nat and bastion host in public subnets and worker node in private subnets. we will connect with EKS cluster using Ec2 bastion host.

- To Run Infrastructure 

  ```bash      
   cd Terraform
   terraform fmt
   terraform init
   terraform plan
   terraform apply
  ```
  
## Build Jenkins Image
- Custiomize jenkins image with kubectl and docker client are built from Docker file and pushed to ECR. 
- we will need kubectl and docker client in CI/CD Jenkins Pipeline.
  
![jenkins-image](https://github.com/salmarefaie/Application_on_EKS/assets/76884936/cdb7d34d-8021-4484-8018-e38061088794)

![jenkins-repo](https://github.com/salmarefaie/Application_on_EKS/assets/76884936/d06c86be-cb31-46da-93ec-33260b4bbb5a)

## Install AWS CLI and kubectl using scripting
- we need to install aws cli and kubectl on ec2 bastion host to connect with EKS cluster using bastion host machine.
- we will connect with bastion host machine using ssh and transfare key to bastion host machine to connect with node worker through bastion host.

 ```bash      
    chmod 400 EKS.pem
    scp -i EKS.pem EKS.pem ec2-user@52.203.64.202:/home/ec2-user
    ssh -i "EKS.pem" ec2-user@52.203.64.202
  ```
  
- install kubectl and aws cli using scripting

 ```bash      
    scp -i EKS.pem install-packages.sh ec2-user@52.203.64.202:/home/ec2-user
    sh install-packages.sh
 ```

## Configuration using Ansible
- another way to install kubectl, aws cli on bastion host machine.
- make config file in ~/.ssh/config


- To run ansible code to machines
 
 ```bash
    cd ansible
    ansible-galaxy init roles/jenkinsDeployment
    ansible-galaxy init roles/aws-cli
    ansible-galaxy init roles/kubectl
    ansible-playbook playbook.yaml -i inventory.txt
 ```
 
 ## Connect to EKS cluster
 - To connect with EKS using ec2 machine, we will configure aws and then connect to the cluster.
 
 ```bash
    aws configure
    aws eks --region us-east-1 update-kubeconfig --name cluster
    kubectl get nodes or kubectl get services
 ```
 
 ## Deploy Jenkins on EKS Cluster
 - transfare yaml files from our machine to bastion host machine.
 
 ```bash
    scp -i EKS.pem Deployment.yaml ec2-user@52.203.64.202:/home/ec2-user
    scp -i EKS.pem Service.yaml ec2-user@52.203.64.202:/home/ec2-user
    scp -i EKS.pem pv.yaml ec2-user@52.203.64.202:/home/ec2-user
    scp -i EKS.pem pvc.yaml ec2-user@52.203.64.202:/home/ec2-user
    scp -i EKS.pem serviceAccount.yaml ec2-user@52.203.64.202:/home/ec2-user
    scp -i EKS.pem Role.yaml ec2-user@52.203.64.202:/home/ec2-user
    scp -i EKS.pem roleBinding.yaml ec2-user@52.203.64.202:/home/ec2-user
    scp -i EKS.pem Namespace.yaml ec2-user@52.203.64.202:/home/ec2-user
 ```
 - apply yaml files to deploy jenkins.
 
 ```bash
    kubectl apply -f namespace.yaml
    kubectl apply -f .
    kubectl get all -n jenkins
 ```
 ![jenkins](https://github.com/salmarefaie/Application_on_EKS/assets/76884936/fb9c1db7-dca2-44e9-a30b-50287ee239a7)


## Deploy Nginx ingress controller
- nginx ingress controller can be deployed by helm or kubernetess
- using helm
```bash
    helm upgrade --install ingress-nginx ingress-nginx 
    repo https://kubernetes.github.io/ingress-nginx 
    namespace ingress-nginx --create-namespace
 ```
 - using kubernetess
 ```bash
     kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.1/deploy/static/provider/cloud/deploy.yaml
 ```

## Deploy Python App
- we will deploy python app with redis on eks cluster using CI/CD jenkins pipeline.
- In CI phase, python app image is built and pushed to docker hub.
- In CD phase, python app with redis is deployed through nginx ingress.


## Steps for jenkins pipeline
- clone repo which have application, Docker file to build image and deployment files to deploy application.

```bash
   git clone https://github.com/salmarefaie/python-app-CI-CD.git
```

- make docker credentials 

![Screenshot from 2023-02-27 03-18-34](https://user-images.githubusercontent.com/76884936/221498361-e8aac26d-f8f4-440f-b2d8-3e6dad76d790.png)

- make pipeline with code which exists in repo (jenkinsfile)

- output from CI/CD phase 

![app](https://github.com/salmarefaie/Application_on_EKS/assets/76884936/00543eeb-5608-4312-87cf-eef3c43e46f6)
