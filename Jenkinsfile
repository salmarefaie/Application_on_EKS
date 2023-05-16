pipeline {
    agent any

    stages {
        stage('CI') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                git 'https://github.com/salmarefaie/python-app-CI-CD'
                sh """
                cd ./Docker_Image_App 
                docker login -u ${USERNAME} -p ${PASSWORD}
                docker build . -f Dockerfile -t salmarefaie29/app-task:v1.0 --network host
                docker push salmarefaie29/app-task:v1.0
                """
                }
            }
        }
         stage('CD') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                git 'https://github.com/salmarefaie/python-app-CI-CD' 
                sh """
                docker login -u ${USERNAME} -p ${PASSWORD}
                kubectl create namespace python-app
                kubectl apply -f /var/jenkins_home/workspace/app-task-pipeline/Deployment/redis-deployment.yaml 
                kubectl apply -f /var/jenkins_home/workspace/app-task-pipeline/Deployment/clusterIP-service.yaml 
                kubectl apply -f /var/jenkins_home/workspace/app-task-pipeline/Deployment/config-map.yaml 
                kubectl apply -f /var/jenkins_home/workspace/app-task-pipeline/Deployment/python-deployment.yaml 
                kubectl apply -f /var/jenkins_home/workspace/app-task-pipeline/Deployment/loadBalancer-service.yaml 
                kubectl apply -f /var/jenkins_home/workspace/app-task-pipeline/Deployment/ingress.yaml 
                """
                }
            }
        }
    }
}