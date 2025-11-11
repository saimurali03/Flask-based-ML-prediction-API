
# ✅ VARIABLES FILE FOR FLASK ML API


variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "aws_account_id" {
  description = "AWS account ID for ECR"
  type        = string
  default     = "331174145079"
}

variable "repo_name" {
  description = "ECR repository name"
  type        = string
  default     = "flask-prediction-api"
}

variable "image_tag" {
  description = "Docker image tag pushed by Jenkins"
  type        = string
  default     = "latest"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = "flask-keypair"  # 
}

variable "ecr_uri" {
  description = "Full ECR URI (passed from Jenkins)"
  type        = string
  default     = "331174145079.dkr.ecr.ap-south-1.amazonaws.com/flask-prediction-api"
}
