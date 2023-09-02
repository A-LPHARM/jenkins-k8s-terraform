pipeline {
	agent {
		kubernetes {
			inheritFrom 'jenkins-agent'
			idleMinutes 5
			yamlFile 'build-pod.yaml'
			defaultContainer 'custom-agent'
		}
	}

	environment {
		AWS_DEFAULT_REGION='us-east-1'
		AWS_CREDENTIALS = credentials('aws-auth')
		PATH = "${PATH}:${getTerraformPath()}"
	}

	stages {
		stage("Checkout") {
			steps{
				sh "echo checkout.."
			}
		}

		stage("Create s3 Bucket"){
			steps{
				script{
					createS3Bucket('raycoy-aws-deploy-jenkins')
				}
			}
		}

		stage("Create DynamoDB") {
			steps{
				script{
					createDynamoDB('raycoy-aws-deploy-jenkins-lock')
				}
			}
		}

		stage("Create ECR_REPO") {
			steps{
				script {
					createECR('aws-deploy-cicd-repo')
				}
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


def createECR(repoName){
    sh returnStatus: true, script: "aws ecr create-repository --repository-name ${repoName} --image-scanning-configuration scanOnPush=true --region ${AWS_DEFAULT_REGION}"
}


def createS3Bucket(bucketName){
    sh returnStatus: true, script: "aws s3 mb s3://${bucketName} --region=${AWS_DEFAULT_REGION}"
}


def createDynamoDB(dynamodbName){
    sh returnStatus: true, script: "aws dynamodb create-table --table-name ${dynamodbName} --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5"
}

def getTerraformPath(){
	def tfHome = tool name: 'terraform:1.4.6', type: 'terraform'
	return tfHome
}