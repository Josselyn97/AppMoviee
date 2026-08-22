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
        LOCAL_BACKEND_IMAGE  = 'api_list_app-backend'
        REMOTE_BACKEND_IMAGE = 'api_list_app-backend'
        
        // --- SOLUCIÓN CRÍTICA DE RED: Forzar límites tolerantes a conexiones lentas ---
        DOCKER_CLIENT_TIMEOUT = '300'
        COMPOSE_HTTP_TIMEOUT  = '300'
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
                    credentialsId: 'DevOps-Practica', 
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    // Intenta subir la imagen hasta 3 veces si la red genera cortes bruscos
                    retry(3) {
                        script {
                            try {
                                sh '''
                                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                                    docker tag \
                                        ${LOCAL_BACKEND_IMAGE}:latest \
                                        $DOCKER_USER/${REMOTE_BACKEND_IMAGE}:${BUILD_NUMBER}

                                    echo "Iniciando subida tolerante a Docker Hub..."
                                    docker push $DOCKER_USER/${REMOTE_BACKEND_IMAGE}:${BUILD_NUMBER}

                                    docker logout
                                '''
                            } catch (Exception e) {
                                echo "Fallo de conexión detectado (EOF/Handshake). Esperando 15 segundos para estabilizar la red antes de reintentar..."
                                // Pausa obligatoria para limpiar el canal de red antes de volver a intentar
                                sleep 15
                                throw e
                            }
                        }
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
