
# ✅ OUTPUTS FILE FOR FLASK ML API

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.flask_ec2.public_ip
}

output "flask_app_url" {
  description = "Public URL of the Flask application"
  value       = "http://${aws_instance.flask_ec2.public_ip}:5000"
}
