pipeline {
    agent any
    
    tools {
        nodejs 'node-18'
    }


    stages {

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t belalmahmoud81/react-app:${BUILD_NUMBER} ."
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {

                    sh "echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin"

                    sh "docker tag belalmahmoud81/react-app:${BUILD_NUMBER} belalmahmoud81/react-app:latest"

                    sh "docker push belalmahmoud81/react-app:${BUILD_NUMBER}"
                    sh "docker push belalmahmoud81/react-app:latest"
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'build/**', allowEmptyArchive: true
            cleanWs()
        }
    }
}
