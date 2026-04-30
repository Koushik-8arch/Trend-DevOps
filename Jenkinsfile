pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/Koushik-8arch/Trend-DevOps.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t kkdochub/trend-app:latest .'
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
                sh 'docker push kkdochub/trend-app:latest'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 80:80 kkdochub/trend-app:latest'
            }
        }
    }
}
