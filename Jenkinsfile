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

        // 1. Instala las dependencias en la raíz
        stage('App - Install') {
            steps {
                sh 'npm ci'
            }
        }

        // 2. Genera Prisma en la raíz
        stage('App - Prisma') {
            steps {
                sh 'npx prisma generate'
            }
        }

        // 3. Ejecuta server.test.js en la raíz
        stage('App - Test') {
            steps {
                sh 'npm test'
            }
        }

        // 4. Valida tu archivo de Docker Compose
        stage('Docker - Validate') {
            steps {
                sh 'docker compose config'
            }
        }

        // 5. Construye el contenedor del proyecto monolítico
        stage('Docker - Build') {
            steps {
                sh 'docker compose build'
            }
        }
    }

    post {
        success {
            echo 'Pipeline satisfactorio'
        }

        failure {
            echo 'Revisar la primera etapa fallida y sus logs'
        }
    }
}
