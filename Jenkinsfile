pipeline {
    agent any

    tools {
        // Herramienta para el Backend (Asegúrate de tener este nombre en tu configuración global de Jenkins)
        nodejs 'NodeJS-24'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            parallel {

                // PIPELINE DEL BACKEND (Ejecutado en la raíz del proyecto)
                stage('Backend Pipeline') {
                    stages {
                        stage('Backend - Install') {
                            steps {
                                // Corre directamente en la raíz porque ahí está tu package.json
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
                    }
                }

                // PIPELINE DEL FRONTEND (Flutter)
                stage('Frontend Pipeline') {
                    stages {
                        stage('Frontend - Install') {
                            steps {
                                // Descarga las dependencias de Flutter
                                sh 'flutter pub get'
                            }
                        }
                        stage('Frontend - Analyze') {
                            steps {
                                // Reemplaza al 'npm run lint' para verificar la calidad del código Dart
                                sh 'flutter analyze'
                            }
                        }
                        stage('Frontend - Test') {
                            steps {
                                // Ejecuta los tests del frontend en Flutter
                                sh 'flutter test'
                            }
                        }
                    }
                }

            }
        }

        // ETAPA DE CONTENEDORES (Docker)
        stage('Docker Services') {
            stages {
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
        }
    }

    post {
        success {
            echo '¡Pipeline completado con éxito para AppMoviee!'
        }
        failure {
            echo 'El pipeline ha fallado. Por favor, revisa los logs de la etapa afectada.'
        }
    }
}
