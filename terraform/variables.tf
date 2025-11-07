variable "region" {
  default = "ap-south-1"
}

variable "key_name" {
  description = "Name of your AWS EC2 key pair"
  default     = "flask-keypair"  # 🔹 Replace this with your actual key pair name
}

variable "image_tag" {
  description = "Docker image tag (passed from Jenkins)"
  default     = "latest"
}

variable "ecr_uri" {
  default = "331174145079.dkr.ecr.ap-south-1.amazonaws.com/flask-prediction-api"
}
