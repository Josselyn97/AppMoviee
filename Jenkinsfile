pipeline {
    agent any

    tools {
        nodejs 'NodeJS-24'
    }

    options {
        timestamps()
    }

    environment {
        // Carpeta portátil dentro del proyecto para las herramientas Docker
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
                    if [ ! -f "$DOCKER_BIN_DIR/docker" ]; then
                        echo "Instalando herramientas de Docker internamente en Jenkins..."
                        mkdir -p $DOCKER_BIN_DIR
                        
                        # ENLACE CORREGIDO: Descarga directa del binario estático de Docker
                        curl -fsSL https://docker.com -o docker.tgz
                        tar -xzf docker.tgz --strip-components=1 -C $DOCKER_BIN_DIR
                        rm docker.tgz
                        
                        # Descarga del ejecutable de Docker Compose (v2)
                        curl -fsSL https://github.com -o $DOCKER_BIN_DIR/docker-compose
                        chmod +x $DOCKER_BIN_DIR/docker-compose
                        
                        # Enlace simbólico interno para soportar el comando 'docker compose' (con espacio)
                        ln -s docker-compose $DOCKER_BIN_DIR/docker-compose-plugin 2>/dev/null || true
                    fi
                    
                    # Comprobación de versiones en la consola
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
            echo 'Pipeline satisfactorio - ¡Tu backend pasó los tests y la imagen Docker fue creada exitosamente!'
        }
        failure {
            echo 'Revisar la primera etapa fallida y sus logs'
        }
    }
}
