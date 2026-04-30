pipeline {
    agent any

    environment {
        IMAGE_NAME = "trend-app"
        DOCKER_USER = "kkdochub"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/Koushik-8arch/Trend-DevOps.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_USER/$IMAGE_NAME:latest ."
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push $DOCKER_USER/$IMAGE_NAME:latest"
            }
        }

        stage('Run Container') {
            steps {
                sh "docker run -d -p 3000:3000 $DOCKER_USER/$IMAGE_NAME:latest"
            }
        }
    }
}
