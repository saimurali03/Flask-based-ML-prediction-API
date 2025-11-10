pipeline {
    agent any

    environment {
        // --- AWS Configuration ---
        AWS_ACCOUNT_ID = "331174145079"
        AWS_REGION = "ap-south-1"

        REPO_NAME = "flask-prediction-api"  // 🔹 Your AWS ECR repo name
        IMAGE_TAG = "latest"
        ECR_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"

        TF_DIR = "terraform"
    }

    stages {

        // 1️⃣ Checkout Code
        stage('Checkout Code from GitHub') {
            steps {
                checkout scm
            }
        }

        // 2️⃣ Configure AWS Credentials
        stage('Configure AWS Credentials') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                  credentialsId: 'AWS-CREDS']]) {
                    echo "✅ AWS Credentials Configured Successfully"
                }
            }
        }

        // 3️⃣ Install Python Dependencies
        stage('Install Dependencies') {
            steps {
                bat """
                    echo 📦 Installing Python Dependencies...
                    pip install -r app\\requirements.txt
                """
            }
        }

        // 4️⃣ Train ML Model
        stage('Train ML Model') {
            steps {
                bat """
                    echo 🧠 Training Machine Learning Model...
                    cd app
                    python train_model.py
                """
            }
        }

        // 5️⃣ Login to AWS ECR
        stage('Login to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                  credentialsId: 'AWS-CREDS']]) {
                    bat """
                        echo 🔐 Logging into AWS ECR...

                        aws configure set aws_access_key_id %AWS_ACCESS_KEY_ID%
                        aws configure set aws_secret_access_key %AWS_SECRET_ACCESS_KEY%
                        aws configure set default.region %AWS_REGION%

                        aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %ECR_URL%
                    """
                }
            }
        }

        // 6️⃣ Build Docker Image
        stage('Build Docker Image') {
            steps {
                bat """
                    echo 🐳 Building Docker Image...
                    docker build --platform linux/amd64 -t ${REPO_NAME} .
                    docker tag ${REPO_NAME}:latest %ECR_URL%:%IMAGE_TAG%
                """
            }
        }

        // 7️⃣ Push Docker Image to ECR
        stage('Push Docker Image to AWS ECR') {
            steps {
                bat """
                    echo 🚀 Pushing Docker Image to ECR...
                    docker push %ECR_URL%:%IMAGE_TAG%
                """
            }
        }
        // 8️⃣ Deploy Infrastructure via Terraform
        stage('Deploy with Terraform') {
            steps {
                dir('terraform') {
                    bat '''
                    echo Initializing Terraform...
                    terraform init -no-color

                    echo Applying Terraform Deployment...
                    terraform apply -auto-approve -no-color -var "image_tag=%IMAGE_TAG%" -var "ecr_uri=%ECR_URL%"
                    '''
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
