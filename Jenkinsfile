pipeline {
    agent any
    stages {
        stage("Checkout") {
            steps{
                sh "echo checkout.."
            }
        }
        stage("AWS ECR Authentication") {
            steps{
                sh "echo Authenticating to AWS..."
            }
        }
        stage("Build & Deploy Image") {
            steps{
                sh "echo Building and Deploying Image..."
            }
        }
        stage("k8s Deployment") {
            steps {
                sh "echo Deploying to Kubernetes..."
            }
        }
    }
}