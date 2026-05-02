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
                git 'https://github.com/Koushik-8arch/Trend-DevOps.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Configure EKS Access') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']]) {
                    sh '''
                        aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml

                    echo "===== POD STATUS ====="
                    kubectl get pods

                    echo "===== SERVICE STATUS ====="
                    kubectl get svc
                '''
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline Completed Successfully 🚀"
        }
        failure {
            echo "Pipeline Failed ❌ Check logs"
        }
    }
}
