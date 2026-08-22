pipeline {
    agent any

    tools {
        nodejs 'NodeJS-24'
    }

    options {
        timestamps()
        skipDefaultCheckout(true)
    }

    environment {
        // Tus variables modificadas se mantienen intactas
        LOCAL_BACKEND_IMAGE  = 'api_list_app-backend'
        REMOTE_BACKEND_IMAGE = 'api_list_app-backend'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Docker Tools') {
            steps {
                sh '''
                    echo "Instalando herramientas oficiales de Docker nativamente..."
                    if command -v apk >/dev/null 2>&1; then
                        apk update && apk add --no-cache docker-cli docker-compose
                    elif command -v apt-get >/dev/null 2>&1; then
                        apt-get update && apt-get install -y docker.io docker-compose
                    else
                        echo "No se pudo determinar el instalador del sistema."
                    fi
                    docker --version
                    docker-compose version || docker compose version
                '''
            }
        }

        stage('Backend - Install') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Backend - Prisma') {
            steps {
                sh 'npx prisma generate'
            }
        }

        stage('Backend - Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Docker - Validate') {
            steps {
                sh 'docker compose config --quiet || docker-compose config --quiet'
            }
        }

        stage('Docker - Build') {
            steps {
                sh 'docker compose build || docker-compose build'
            }
        }

        stage('Docker - Verify Images') {
            steps {
                sh 'docker image inspect ${LOCAL_BACKEND_IMAGE} > /dev/null'
            }
        }

        stage('Docker - Publish') {
            steps {
                withCredentials([usernamePassword(
                    // Tu nueva credencial configurada se mantiene intacta
                    credentialsId: 'DevOps-Practica', 
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    // SOLUCIÓN: Reintenta automáticamente hasta 3 veces si la red falla (EOF)
                    retry(3) {
                        sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                            docker tag \
                                ${LOCAL_BACKEND_IMAGE}:latest \
                                $DOCKER_USER/${REMOTE_BACKEND_IMAGE}:${BUILD_NUMBER}

                            echo "Iniciando subida a Docker Hub..."
                            docker push $DOCKER_USER/${REMOTE_BACKEND_IMAGE}:${BUILD_NUMBER}

                            docker logout
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline satisfactorio'
            echo 'Imagen de Backend publicada correctamente en Docker Hub'
        }

        failure {
            echo 'Revisar la primera etapa fallida y sus logs'
        }

        always {
            sh 'docker logout || true'
        }
    }
}
