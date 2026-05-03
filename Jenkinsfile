pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kkdochub/trend:${BUILD_NUMBER}"
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
                    docker tag $DOCKER_IMAGE kkdochub/trend:latest
                '''
            }
        }

        stage('DockerHub Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE
                        docker push kkdochub/trend:latest
                    '''
                }
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

                        aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME

                        export KUBECONFIG=/var/lib/jenkins/.kube/config

                        echo "Deploying to Kubernetes..."
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml

                        echo "Waiting for rollout..."
                        kubectl rollout status deployment/trend-app

                        echo "Pods:"
                        kubectl get pods -o wide

                        echo "Service:"
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
