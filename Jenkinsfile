pipeline {
    agent any

    tools {
        nodejs 'NodeJS-24'
    }

    options {
        timestamps()
    }

    environment {
        // Creamos una carpeta temporal dentro de Jenkins para colocar los comandos de Docker
        DOCKER_BIN_DIR = "${WORKSPACE}/docker_bin"
        PATH           = "${DOCKER_BIN_DIR}:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // --- ETAPA NUEVA: Descarga automática de Docker e integración interna ---
        stage('Setup Docker Tools') {
            steps {
                sh '''
                    if [ ! -f "$DOCKER_BIN_DIR/docker" ]; then
                        echo "Instalando herramientas de Docker internamente en Jenkins..."
                        mkdir -p $DOCKER_BIN_DIR
                        
                        # Descarga los binarios estáticos oficiales de Docker para Linux
                        curl -fsSL https://docker.com -o docker.tgz
                        tar -xzf docker.tgz --strip-components=1 -C $DOCKER_BIN_DIR
                        rm docker.tgz
                        
                        # Descarga el componente oficial de Docker Compose (v2)
                        curl -fsSL https://github.com -o $DOCKER_BIN_DIR/docker-compose
                        chmod +x $DOCKER_BIN_DIR/docker-compose
                        
                        # Crear un alias temporal para soportar el comando clásico 'docker compose' con espacio
                        ln -s docker-compose $DOCKER_BIN_DIR/docker-compose-plugin 2>/dev/null || true
                    fi
                    
                    # Verificar que Jenkins ahora sí los reconozca de inmediato
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
                // Reemplazamos por 'docker-compose config' para asegurar máxima compatibilidad interna
                sh 'docker-compose config'
            }
        }

        stage('Docker - Build') {
            steps {
                // Reemplazamos por 'docker-compose build' para empaquetar tu backend en la imagen
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
