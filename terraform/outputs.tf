output "app_url" {
  description = "Public URL of Flask App"
  value       = "http://${aws_instance.flask_ec2.public_ip}:5000"
}

output "public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.flask_ec2.public_ip
}
