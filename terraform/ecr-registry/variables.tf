
variable "region" {
  description = "Default region for my s3 bucket"
  type        = string
  default     = "us-east-1"
}


variable "tenancy" {
  default = "default"
}

variable "registry_name" {
  type = string
}

