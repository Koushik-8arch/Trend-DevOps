pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kkdochub/trend:latest"
        AWS_REGION = "ap-south-1"
        CLUSTER_NAME = "trend-cluster"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Koushik-8arch/Trend-DevOps.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker Image..."
                    docker build -t $DOCKER_IMAGE .
                '''
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    echo "Pushing Docker Image..."
                    docker push $DOCKER_IMAGE
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-cred'
                ]]) {
                    sh '''
                        echo "Configuring AWS..."
                        aws sts get-caller-identity

                        echo "Updating kubeconfig..."
                        aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME

                        export KUBECONFIG=/var/lib/jenkins/.kube/config

                        echo "Checking cluster access..."
                        kubectl get nodes

                        echo "Deploying to Kubernetes..."
                        kubectl apply -f deployment.yaml --validate=false
                        kubectl apply -f service.yaml --validate=false

                        echo "===== POD STATUS ====="
                        kubectl get pods -o wide

                        echo "===== SERVICE STATUS ====="
                        kubectl get svc
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD Pipeline Completed Successfully 🚀"
        }
        failure {
            echo "❌ Pipeline Failed - Check Logs"
        }
    }
}
