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
                // --no-cache ensures fresh build every time
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
                    docker rmi ${IMAGE_TAG} || true
                """
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline succeeded! Image pushed: ${IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline failed. Check console: ${BUILD_URL}console"
        }
        always {
            // ✅ Fixed: Vite outputs to dist/ not build/
            archiveArtifacts artifacts: 'dist/**', allowEmptyArchive: true
            cleanWs()
        }
    }
}
