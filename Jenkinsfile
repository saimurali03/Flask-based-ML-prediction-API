pipeline {
    agent any

    environment {
        // --- AWS Configuration ---
        AWS_DEFAULT_REGION = 'ap-south-1'       // Change if using a different AWS region
        ECR_REPO = 'flask-prediction-api'       // Your AWS ECR repository name
        IMAGE_TAG = "v${BUILD_NUMBER}"          // Auto increments on every Jenkins build
        ECR_URI = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/${ECR_REPO}" // Replace with your AWS account ID
    }

    stages {

        // 1️⃣ Checkout Code
        stage('Checkout') {
            steps {
                git 'https://github.com/saimurali03/Flask-based-ML-prediction-API' // Replace with your repo URL
            }
        }

        // 2️⃣ Train ML Model
        stage('Train Model') {
            steps {
                sh 'python app/train_model.py'
            }
        }

        // 3️⃣ Build Docker Image
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
            }
        }

        // 4️⃣ Login to AWS ECR
        stage('Login to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                    aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_URI
                    '''
                }
            }
        }

        // 5️⃣ Push Docker Image to AWS ECR
        stage('Push Image to ECR') {
            steps {
                sh '''
                docker tag $ECR_REPO:$IMAGE_TAG $ECR_URI:$IMAGE_TAG
                docker push $ECR_URI:$IMAGE_TAG
                '''
            }
        }

        // 6️⃣ Deploy to AWS EC2 using Terraform
        stage('Terraform Deploy') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    dir('terraform') {
                        sh '''
                        terraform init
                        terraform apply -auto-approve \
                            -var="image_tag=$IMAGE_TAG" \
                            -var="ecr_uri=$ECR_URI"
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful! Visit your Flask app on AWS EC2."
        }
        failure {
            echo "❌ Deployment Failed. Check Jenkins logs."
        }
    }
}
