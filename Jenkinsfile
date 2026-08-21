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
        // Ajustado solo para tu Backend (Eliminado el Frontend)
        LOCAL_BACKEND_IMAGE  = 'api_list_app-backend'
        REMOTE_BACKEND_IMAGE = 'api_list_app-backend'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // ETAPA CLAVE: Asegura que los comandos de Docker estén disponibles nativamente
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

        // --- ETAPAS DEL BACKEND (Raíz del proyecto) ---
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

        // --- ETAPAS DE DOCKER ---
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
                // Solo verifica la imagen del backend que realmente existe
                sh 'docker image inspect ${LOCAL_BACKEND_IMAGE} > /dev/null'
            }
        }

        stage('Docker - Publish') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'DevOps-Practica', // Asegúrate de tener este ID creado en Jenkins Credentials
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                        # Taggear y subir únicamente la imagen del backend
                        docker tag \
                            ${LOCAL_BACKEND_IMAGE}:latest \
                            $DOCKER_USER/${REMOTE_BACKEND_IMAGE}:${BUILD_NUMBER}

                        docker push \
                            $DOCKER_USER/${REMOTE_BACKEND_IMAGE}:${BUILD_NUMBER}

                        docker logout
                    '''
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
