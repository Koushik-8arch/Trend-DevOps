pipeline {
    agent any

    stages {

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t kkdochub/trend-app:latest .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'c4776af1-5bda-4bfe-8b4a-38b2f94d90ee',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push kkdochub/trend-app:latest'
            }
        }

        stage('Cleanup Old Containers') {
            steps {
                sh 'docker rm -f $(docker ps -aq) || true'
            }
        }

        stage('Run Container') {
    steps {
        sh '''
        docker rm -f trend-app || true
        docker run -d --name trend-app -p 80:80 kkdochub/trend-app:latest
        '''
            }
        }

        stage('Cleanup System') {
            steps {
                sh 'docker system prune -af || true'
            }
        }
    }
}
