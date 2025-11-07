# Flask-based-ML-prediction-API
### Tools Used
- **AWS:** EC2, ECR
- **DevOps:** Jenkins, Docker, Terraform

### Workflow
1. Jenkins triggers build on Git push.
2. Docker image is built and pushed to ECR.
3. Terraform provisions EC2 and deploys the container.
4. Flask ML API becomes available at `http://<EC2-IP>:5000/predict`.
