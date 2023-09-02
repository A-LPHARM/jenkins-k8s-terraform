
data "aws_ecr_repository" "repository" {
   name = "aws-deploy-cicd-repo"
}


output "registry_id" {
  description = "The account ID of the registry holding the repository."
  value = data.aws_ecr_repository.repository.registry_id
}

output "repository_name" {
  description = "The name of the repository."
  value = data.aws_ecr_repository.repository.name
}

output "repository_url" {
  description = "The URL of the repository."
  value = data.aws_ecr_repository.repository.repository_url
}