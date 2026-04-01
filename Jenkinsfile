pipeline {
    agent any

    tools {
        nodejs 'node-18'
    }

    environment {
        IMAGE_NAME = "belalmahmoud81/react-app"
        IMAGE_TAG  = "${IMAGE_NAME}:${BUILD_NUMBER}"
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
                sh "docker build --no-cache -t ${IMAGE_TAG} ."
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker tag $IMAGE_NAME:$BUILD_NUMBER $IMAGE_NAME:latest
                        docker push $IMAGE_NAME:$BUILD_NUMBER
                        docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    docker rm -f react-app || true
                    docker run -d --name react-app -p 3000:80 ${IMAGE_TAG}
                """
            }
        }

        stage('Cleanup') {                              
            steps {
                sh """
                    echo "🧹 Starting cleanup..."

                    docker rmi ${IMAGE_TAG} || true
                    docker image prune -f || true
                    docker builder prune --filter "until=24h" -f || true

                    echo "📊 Docker disk usage after cleanup:"
                    docker system df

                    echo "✅ Cleanup complete!"
                """
            }
        }                                              

    }                                                   // ✅ end of stages

   
    post {
        success {
            slackSend(
                channel: '#nodejs-pipline',
                color: 'good',
                message: "✅ Build SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${env.BUILD_URL}"
            )
        }
        failure {
            slackSend(
                channel: '#nodejs-pipline',
                color: 'danger',
                message: "❌ Build FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${env.BUILD_URL}"
            )
        }
        always {                                     
            archiveArtifacts artifacts: 'dist/**', allowEmptyArchive: true
            cleanWs()
        }
    }

}
