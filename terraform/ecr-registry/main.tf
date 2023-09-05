
data "aws_ecr_repository" "repository" {
   name = "aws-deploy-cicd-repo"
}

# the aim is to create a registry_id or number in laymans terms
output "registry_id" {
  description = "The account ID of the registry holding the repository."
  value = data.aws_ecr_repository.repository.registry_id
} 

#Creating a repository name
output "repository_name" {
  description = "The name of the repository."
  value = data.aws_ecr_repository.repository.name
}  

#creating a repoistory url so u can access it. on your aws console
output "repository_url" {
  description = "The URL of the repository."
  value = data.aws_ecr_repository.repository.repository_url
}  