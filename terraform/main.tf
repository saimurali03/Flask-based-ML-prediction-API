#########################################
# ✅ MAIN CONFIGURATION FOR FLASK ML API
#########################################

provider "aws" {
  region = var.aws_region
}

#########################################
# ✅ Input Variables (from Jenkins)
#########################################

variable "aws_region" {
  description = "AWS region to deploy in"
  type        = string
  default     = "ap-south-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "repo_name" {
  description = "ECR repository name"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag (from Jenkins)"
  type        = string
  default     = "latest"
}

variable "ecr_uri" {
  description = "Full ECR URI passed dynamically from Jenkins"
  type        = string
}

#########################################
# ✅ Security Group for Flask App
#########################################

resource "aws_security_group" "flask_sg" {
  name        = "flask_ml_api_sg"
  description = "Allow inbound HTTP (5000) and SSH (22) access"

  ingress {
    description = "Flask app port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FlaskMLAppSecurityGroup"
  }
}

#########################################
# ✅ EC2 Instance for Flask Docker Container
#########################################

resource "aws_instance" "flask_ec2" {
  ami           = "ami-0305d3d91b9f22e84" # ✅ Ubuntu 20.04 AMI (for ap-south-1)
  instance_type = "t3.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker

              # Login to AWS ECR
              aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.ecr_uri}

              # Pull latest Docker image and run Flask app
              docker pull ${var.ecr_uri}:${var.image_tag}
              docker run -d -p 5000:5000 ${var.ecr_uri}:${var.image_tag}
              EOF

  tags = {
    Name = "Flask-ML-Prediction-API"
  }
}

#########################################
# ✅ Outputs (for Jenkins display)
#########################################

output "instance_public_ip" {
  value = aws_instance.flask_ec2.public_ip
}

output "flask_app_url" {
  value = "http://${aws_instance.flask_ec2.public_ip}:5000"
}
