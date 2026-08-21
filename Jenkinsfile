pipeline {
    agent any

    tools {
        nodejs 'NodeJS-24'
    }

    options {
        timestamps()
    }

    environment {
        DOCKER_BIN_DIR = "${WORKSPACE}/docker_bin"
        PATH           = "${DOCKER_BIN_DIR}:${env.PATH}"
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
                    # Forzar la limpieza de archivos corruptos anteriores si existen
                    rm -f docker.tgz
                    rm -rf $DOCKER_BIN_DIR
                    
                    echo "Instalando herramientas de Docker de forma limpia..."
                    mkdir -p $DOCKER_BIN_DIR
                    
                    # DESCARGA DEFINITIVA DEL BINARIO REAL
                    curl -fsSL https://docker.com -o docker.tgz
                    tar -xzf docker.tgz --strip-components=1 -C $DOCKER_BIN_DIR
                    rm -f docker.tgz
                    
                    # Descarga de Docker Compose v2
                    curl -fsSL https://github.com -o $DOCKER_BIN_DIR/docker-compose
                    chmod +x $DOCKER_BIN_DIR/docker-compose
                    
                    # Enlace para comando docker compose con espacio
                    ln -s docker-compose $DOCKER_BIN_DIR/docker-compose-plugin 2>/dev/null || true
                    
                    docker --version
                    docker-compose version
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
                sh 'docker-compose config'
            }
        }

        stage('Docker - Build') {
            steps {
                sh 'docker-compose build'
            }
        }
    }

    post {
        success {
            echo 'Pipeline satisfactorio - ¡Imágenes creadas exitosamente!'
        }
        failure {
            echo 'Revisar la primera etapa fallida y sus logs'
        }
    }
}
