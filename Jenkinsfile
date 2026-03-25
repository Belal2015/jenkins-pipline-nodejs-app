pipeline {
    agent any

    tools {
        nodejs 'node-18'
    }

    environment {
        IMAGE_NAME = "belalmahmoud81/react-app"
    }

    stages {

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test -- --watchAll=false --passWithNoTests'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                // ✅ BUILD_NUMBER is a Jenkins built-in, safe with double quotes
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    // ✅ Single quotes - shell variables, not Groovy interpolation
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker tag $IMAGE_NAME:$BUILD_NUMBER $IMAGE_NAME:latest
                        docker push $IMAGE_NAME:$BUILD_NUMBER
                        docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Cleanup') {
            steps {
                // ✅ Remove local images to free disk space
                sh '''
                    docker rmi $IMAGE_NAME:$BUILD_NUMBER || true
                    docker rmi $IMAGE_NAME:latest || true
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline succeeded! Image pushed: ${IMAGE_NAME}:${BUILD_NUMBER}"
        }
        failure {
            echo "❌ Pipeline failed at stage. Check logs above."
        }
        always {
            archiveArtifacts artifacts: 'build/**', allowEmptyArchive: true
            cleanWs()
        }
    }
}
