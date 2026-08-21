pipeline {
    agent any

    tools {
        // Herramienta oficial para Node.js configurada en tu Jenkins
        nodejs 'NodeJS-24'
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                // Descarga el código limpio de tu repositorio
                checkout scm
            }
        }

        stage('Backend - Install') {
            steps {
                // Instala las dependencias en la raíz del proyecto
                sh 'npm ci'
            }
        }

        stage('Backend - Prisma') {
            steps {
                // Genera el cliente de Prisma ORM
                sh 'npx prisma generate'
            }
        }

        stage('Backend - Test') {
            steps {
                // Ejecuta Jest y pasa tus pruebas de integración de manera exitosa
                sh 'npm test'
            }
        }
        
        // Nota: Se removieron las etapas de "Docker - Validate" y "Docker - Build"
        // debido a la falta del binario de Docker en el agente de Jenkins.
    }

    post {
        success {
            echo 'Pipeline satisfactorio - ¡Tu proyecto AppMoviee está verificado!'
        }

        failure {
            echo 'Revisar la primera etapa fallida y sus logs'
        }
    }
}
