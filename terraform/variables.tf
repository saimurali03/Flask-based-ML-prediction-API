#########################################
# ✅ VARIABLES FILE FOR FLASK ML API
#########################################

variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "ap-south-1"
}

variable "aws_account_id" {
  description = "AWS account ID for ECR"
  default     = "331174145079"
}

variable "repo_name" {
  description = "ECR repository name"
  default     = "flask-prediction-api"
}

variable "image_tag" {
  description = "Docker image tag pushed by Jenkins"
  default     = "latest"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  default     = "flask-keypair"  # Change to your actual key pair
}
