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
                sh "Authenticating to AWS..."
            }
        }
        stage("Build & Deploy Image") {
            steps{
                sh "Building and Deploying Image..."
            }
        }
        stage("k8s Deployment") {
            steps {
                sh "Deploying to Kubernetes..."
            }
        }
    }
}