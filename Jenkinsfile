pipeline {
    agent any

    tools {
        nodejs 'NodeJS-24'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        // Definimos una ruta local dentro del espacio de trabajo para instalar Flutter de forma portátil
        FLUTTER_HOME = "${WORKSPACE}/flutter_sdk"
        PATH         = "${FLUTTER_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            parallel {

                // PIPELINE DEL BACKEND
                stage('Backend Pipeline') {
                    steps {
                        sh 'npm ci'
                        sh 'npx prisma generate'
                        sh 'npm test'
                    }
                }

                // PIPELINE DEL FRONTEND (Descarga e instalación automática y limpia)
                stage('Frontend Pipeline') {
                    steps {
                        // Detecta si Flutter ya está descargado en el espacio de trabajo, si no, lo descarga.
                        sh '''
                            if [ ! -d "$FLUTTER_HOME" ]; then
                                echo "Instalando Flutter SDK de forma portátil..."
                                git clone https://github.com -b stable --depth 1 $FLUTTER_HOME
                            fi
                        '''
                        
                        // Forzar pre-descarga de binarios necesarios y deshabilitar analíticas molestas en Jenkins
                        sh 'flutter config --no-analytics'
                        sh 'flutter doctor --version'

                        // Ejecución de pruebas y validaciones del Frontend
                        sh 'flutter pub get'
                        sh 'flutter analyze'
                        sh 'flutter test'
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
