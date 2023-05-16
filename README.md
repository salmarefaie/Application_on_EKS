# Application_on_EKS

## Description
- Create a simple infrastructure on aws to make secure cluster eks using terraform.
- Deploy and Configure Jenkins on EKS.
- Deploy python app application on EKS cluster using CI/CD jenkins pipeline.


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

  ![Untitled Diagram drawio](https://user-images.githubusercontent.com/76884936/221486336-3dd39189-b5a3-41c1-93ef-261448e484b0.png)

- To Run Infrastructure 

  ```bash      
   cd Terraform
   terraform init
   terraform plan
   terraform apply
  ```
  
## Build Jenkins Image
- Custiomize jenkins image with kubectl and docker client are built from Docker file and pushed to docker hub. 
- we will need kubectl and docker client in CI/CD Jenkins Pipeline.

  ```bash      
    docker build -t jenkins-image-on-pod .
    docker tag jenkins-image-on-pod salmarefaie29/jenkins-image-on-pod
    docker images
    docker push salmarefaie29/jenkins-image-on-pod
  ```
  
  ![Screenshot from 2023-02-27 01-13-22](https://user-images.githubusercontent.com/76884936/221487573-7367fe83-785d-4527-8a9e-b028bd6ff6d1.png)

## Install AWS CLI and kubectl 
- we need to install aws cli and kubectl on ec2 bastion host to connect with EKS cluster using bastion host machine.
- we will connect with bastion host machine using ssh and transfare key to bastion host machine to connect with node worker through bastion host.

 ```bash      
    chmod 400 project.pem
    scp -i project.pem project.pem ubuntu@3.86.85.134:/home/ubuntu
    ssh -i "project.pem" ubuntu@3.86.85.134
  ```
  
- install kubectl and aws cli using scripting

 ```bash      
    scp -i project.pem install-packages.sh ubuntu@3.86.85.134:/home/ubuntu
    sh install-packages.sh
 ```
 
 ## Enable Docker 
 - we can enable docker manually on node worker and we connect to node worker through bastion host.
 
 ```bash      
    ssh -i "project.pem" ec2-user@10.0.3.18
    sudo systemctl start docker
    sudo systemctl status docker
 ```

## Configuration using Ansible
- another way to install kubectl, aws cli on bastion host machine and enable docker on node worker.
- make config file in ~/.ssh/config

```bash      
   Host bastion-host
        hostname 3.86.85.134
        user ubuntu
        port 22
        identityfile /home/salma/ITI-Devops/final-project/ansible/project.pem
 ```
 - To run ansible code to machines
 
 ```bash
    cd ansible
    ansible-galaxy init roles/docker
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
    scp -i project.pem deployment.yaml ubuntu@3.86.85.134:/home/ubuntu
    scp -i project.pem service.yaml ubuntu@3.86.85.134:/home/ubuntu
    scp -i project.pem pv.yaml ubuntu@3.86.85.134:/home/ubuntu
    scp -i project.pem pvc.yaml ubuntu@3.86.85.134:/home/ubuntu
    scp -i project.pem service-account.yaml ubuntu@3.86.85.134:/home/ubuntu
    scp -i project.pem role.yaml ubuntu@3.86.85.134:/home/ubuntu
    scp -i project.pem role-binding.yaml ubuntu@3.86.85.134:/home/ubuntu
    scp -i project.pem namespace.yaml ubuntu@3.86.85.134:/home/ubuntu
 ```
 - apply yaml files to deploy jenkins.
 
 ```bash
    kubectl apply -f namespace.yaml
    kubectl apply -f pv.yaml
    kubectl apply -f pvc.yaml
    kubectl apply -f service-account.yaml
    kubectl apply -f role.yaml
    kubectl apply -f role-binding.yaml
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    kubectl get all -n jenkins
    kubectl logs pod/jenkins-78679c566d-pc8lr -n jenkins
 ```
 
  ![Screenshot from 2023-02-27 03-17-32](https://user-images.githubusercontent.com/76884936/221494787-684c0e42-cb49-4fa5-96d1-04122f0dbeee.png)

## Deploy Python App
- we will deploy python app with redis on eks cluster using CI/CD jenkins pipeline.
- In CI phase, python app image is built and pushed to docker hub.
- In CD phase, python app with redis is deployed.

  ![Screenshot from 2023-02-27 09-07-08](https://user-images.githubusercontent.com/76884936/221496885-5e6e73e7-121c-4541-b0b8-0ae72703d3e4.png)

## Steps for jenkins pipeline
- clone repo which have application, Docker file to build image and deployment files to deploy application.

```bash
   git clone https://github.com/salmarefaie/python-app-CI-CD.git
```

- make docker credentials 

![Screenshot from 2023-02-27 03-18-34](https://user-images.githubusercontent.com/76884936/221498361-e8aac26d-f8f4-440f-b2d8-3e6dad76d790.png)

- make pipeline with code which exists in repo (jenkinsfile)

 ![Screenshot from 2023-02-27 03-32-34](https://user-images.githubusercontent.com/76884936/221499118-5f8e7557-fcd3-4606-b45a-6f353d192515.png)
 
 ![Screenshot from 2023-02-27 03-37-26](https://user-images.githubusercontent.com/76884936/221499269-73a24f1d-73fc-4a56-95db-71a4381f1b40.png)
 
- output from CI phase 

![Screenshot from 2023-02-27 09-23-06](https://user-images.githubusercontent.com/76884936/221499761-e28860f5-80b0-4a2f-a5ae-7d20c1089b4f.png)

- output from CD phase 

![Screenshot from 2023-02-27 03-37-29](https://user-images.githubusercontent.com/76884936/221499887-db1d825d-46ec-47ae-9d88-abd98ab816cc.png)

