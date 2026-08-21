pipeline {
    agent any

    tools {
        // Herramienta configurada en tu Jenkins para Node.js
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

        // --- ETAPAS DE TU BACKEND (Raíz del proyecto) ---
        stage('Backend - Install') {
            steps {
                // Se quitó dir('backend') porque tus archivos están en la raíz
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
                sh 'docker compose config'
            }
        }

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
