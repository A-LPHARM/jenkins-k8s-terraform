provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket = "henry-aws-deploy-jenkins"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "henry-aws-deploy-jenkins-lock"
  }
}