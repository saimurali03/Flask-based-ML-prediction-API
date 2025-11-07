provider "aws" {
  region = var.region
}

# Create an EC2 instance
resource "aws_instance" "flask_ec2" {
  ami           = "ami-0305d3d91b9f22e84" 
  instance_type = "t3.micro"
  key_name      = var.key_name

  # EC2 User Data to install Docker and run container
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo docker run -d -p 5000:5000 ${var.ecr_uri}:${var.image_tag}
              EOF

  tags = {
    Name = "FlaskMLApp"
  }
}

# Security group to allow HTTP (5000) and SSH access
resource "aws_security_group" "flask_sg" {
  name        = "flask-app-sg"
  description = "Allow inbound HTTP (5000) and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Flask App Port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FlaskAppSG"
  }
}

# Attach security group to EC2
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.flask_sg.id
  network_interface_id = aws_instance.flask_ec2.primary_network_interface_id
}

# Fetch default VPC for the security group
data "aws_vpc" "default" {
  default = true
}
