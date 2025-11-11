pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "331174145079"
        AWS_REGION = "us-east-1" // Public ECR must use us-east-1
        TF_AWS_REGION = "ap-south-1" // EC2 deployment region

        REPO_NAME = "flask-prediction-api"
        IMAGE_TAG = "latest"
        ECR_URL = "public.ecr.aws/a8f4x2n0/flask-prediction-api"

        TF_DIR = "terraform"
    }

    stages {
        stage('Checkout Code from GitHub') {
            steps {
                checkout scm
            }
        }

        stage('Configure AWS Credentials') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS-CREDS']]) {
                    echo "✅ AWS Credentials Configured Successfully"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                bat """
                    echo 📦 Installing Python Dependencies...
                    pip install -r app\\requirements.txt
                """
            }
        }

        stage('Train ML Model') {
            steps {
                bat """
                    echo 🧠 Training Machine Learning Model...
                    cd app
                    python train_model.py
                """
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withAWS(credentials: 'AWS-CREDS', region: 'us-east-1') {
                    bat '''
                        echo 🔐 Logging into AWS Public ECR...
                        aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/a8f4x2n0
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                    echo 🐳 Building Docker Image...
                    docker build --platform linux/amd64 -t %REPO_NAME% .
                    docker tag %REPO_NAME%:latest %ECR_URL%:%IMAGE_TAG%
                """
            }
        }

        stage('Push Docker Image to AWS ECR') {
            steps {
                bat """
                    echo 🚀 Pushing Docker Image to ECR...
                    docker push %ECR_URL%:%IMAGE_TAG%
                """
            }
        }

        stage('Deploy with Terraform') {
            steps {
                withAWS(credentials: 'AWS-CREDS', region: 'ap-south-1') {
                    dir('terraform') {
                        bat """
                            terraform init -no-color
                            terraform apply -auto-approve -no-color -var "image_tag=%IMAGE_TAG%" -var "ecr_uri=%ECR_URL%"
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful! Flask ML API is Live on AWS"
        }
        failure {
            echo "❌ Deployment Failed. Check Jenkins logs for details."
        }
    }
}
