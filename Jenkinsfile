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
		
		stage("Create s3 Bucket"){
			steps{
				script{
					createS3Bucket('henry-aws-deploy-jenkins')
				}
			}
		}

		stage("Create DynamoDB") {
			steps{
				script{
					createDynamoDB('henry-aws-deploy-jenkins-lock')
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

		
		stage("Terraform Init & Apply") {
			steps{
				dir('terraform/ecr_registry') {
                    sh "pwd"
					sh "terraform init"
                    sh "terraform init -upgrade"
                    sh "terraform apply -auto-approve -var-file=dev.tfvars"
                    script{
                        REGISTRY_ID = sh(returnStdout: true, script: "terraform output registry_id").trim()
                        REPOSITORY_NAME = sh(returnStdout: true, script: "terraform output repository_name").trim()
                        REPOSITORY_URL = sh(returnStdout: true, script: "terraform output repository_url").trim()
                    }
                }
			}
		}



		stage("AWS ECR Authentication") {
			steps{
				container('custom-agent') {
					sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${REGISTRY_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
				}
			}
		}

		stage("Build & Deploy Image") {
			steps{
				sh "docker image build -t ${REPOSITORY_NAME}:${BUILD_ID} ."
                sh "docker tag ${REPOSITORY_NAME}:${BUILD_ID} ${REPOSITORY_URL}:${BUILD_ID}"
                sh "docker push ${REPOSITORY_URL}:${BUILD_ID}"
				sh "docker image rmi -f ${REPOSITORY_NAME}:${BUILD_ID}"
				sh "docker image rmi -f ${REPOSITORY_URL}:${BUILD_ID}"
 			}
		}

		stage("k8s Deployment"){
			steps {
				script {
					withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'jenkins-kubernetes-credential', namespace: '', restrictKubeConfigAccess: false, serverUrl: 'https://api-henry-new-kops-k8s-lo-qj41rc-3802eb931be6db38.elb.us-east-1.amazonaws.com') {
						sh returnStatus: true, script: 'kubectl create secret docker-registry regcred --docker-server=${REGISTRY_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password)'
						sh 'kubectl apply -f k8sbook.yaml'
						sh 'envsubst < kjavaapps.yaml | kubectl apply -f -'
					}
				}
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


def REGISTRY_ID 

def REPOSITORY_NAME

def REPOSITORY_URL