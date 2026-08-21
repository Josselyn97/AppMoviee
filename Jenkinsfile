pipeline {
    agent any

    tools {
        nodejs 'NodeJS-24'
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Docker Tools') {
            steps {
                // Instalación limpia y nativa mediante el gestor de paquetes de Linux
                sh '''
                    echo "Instalando herramientas oficiales de Docker nativamente..."
                    
                    # Detectar el gestor de paquetes e instalar Docker y Docker Compose
                    if command -v apk >/dev/null 2>&1; then
                        apk update && apk add --no-cache docker-cli docker-compose
                    elif command -v apt-get >/dev/null 2>&1; then
                        apt-get update && apt-get install -y docker.io docker-compose
                    else
                        echo "No se pudo determinar el instalador del sistema."
                    fi

                    # Verificar reconocimiento inmediato
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
                // Intenta validar usando la sintaxis disponible en el sistema
                sh 'docker compose config || docker-compose config'
            }
        }

        stage('Docker - Build') {
            steps {
                // Compila la imagen de tu Backend
                sh 'docker compose build || docker-compose build'
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
