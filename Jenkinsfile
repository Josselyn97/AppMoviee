pipeline {
    agent any

    tools {
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

                // PIPELINE DEL BACKEND (Usa el agente base de Jenkins)
                stage('Backend Pipeline') {
                    steps {
                        // Agrupamos en un solo bloque script para mayor orden
                        sh 'npm ci'
                        sh 'npx prisma generate'
                        sh 'npm test'
                    }
                }

                // PIPELINE DEL FRONTEND (Usa un contenedor temporal con Flutter)
                stage('Frontend Pipeline') {
                    agent {
                        docker {
                            // Imagen oficial ligera de Flutter (puedes cambiar la versión si lo requieres)
                            image 'ghcr.io/cirruslabs/flutter:3.24.0'
                            // Reutiliza el directorio de Jenkins dentro del contenedor
                            reuseNode true 
                        }
                    }
                    stages {
                        stage('Frontend - Install') {
                            steps {
                                sh 'flutter pub get'
                            }
                        }
                        stage('Frontend - Analyze') {
                            steps {
                                sh 'flutter analyze'
                            }
                        }
                        stage('Frontend - Test') {
                            steps {
                                sh 'flutter test'
                            }
                        }
                    }
                }

            }
        }

        // ETAPA DE CONTENEDORES
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
