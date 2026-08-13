# APPmovilMovie (api_list_app)

Una aplicación móvil desarrollada en **Flutter** para la visualización de películas, conectada a un servidor backend en **Node.js** para la gestión y flujo de datos de la API.

---

## 📋 Requisitos Previos

Antes de instalar y ejecutar el proyecto, asegúrate de tener instalado lo siguiente:

* **Flutter SDK** (Versión 3.x o superior)
* **Dart SDK** (Incluido con Flutter)
* **Node.js** (Versión 18.x o superior) y **npm**
* **Docker** y **Docker Compose**
* Un editor de código (**VS Code** o **Android Studio**)
* Herramientas de emulación (**Android Emulator**, **iOS Simulator** o navegador Web)

---

## ⚙️ Instrucciones de Instalación

Sigue estos pasos para configurar el entorno local:

### 1. Clonar el repositorio
```bash
git clone https://github.com/Josselyn97/AppMoviee.git
cd AppMoviee
```

### 2. Configurar el Backend (Node.js)
Instala las dependencias necesarias para el servidor:
```bash
npm install
```

### 3. Configurar el Frontend (Flutter)
Obtén todos los paquetes y dependencias de Flutter:
```bash
flutter pub get
```

### 4. Variables de Entorno
Crea un archivo `.env` en la raíz del proyecto (basándote en el archivo `.env` existente) y configura la URL de la API o las credenciales necesarias.

---

## 🧪 Comando para Ejecutar las Pruebas

El proyecto cuenta con suites de pruebas tanto para el servidor como para la aplicación móvil.

### Pruebas del Backend (Node.js)
Para ejecutar los tests automatizados del servidor:
```bash
npm test
```

### Pruebas del Frontend (Flutter)
Para ejecutar los tests unitarios y de componentes de la app móvil:
```bash
flutter test
```

---

## 🐳 Comandos para Construir y Ejecutar la Imagen Docker

Si prefieres desplegar y aislar el servidor utilizando contenedores de Docker:

### 1. Construir la imagen Docker
```bash
docker build -t app-moviee-server .
```

### 2. Ejecutar el contenedor individual
```bash
docker run -d -p 3000:3000 --name moviee-backend app-moviee-server
```

---

## 🚀 Uso de Docker Compose

Para levantar todo el entorno de servicios de manera automática y coordinada, utiliza el archivo `docker-compose.yml` incluido en la raíz:

### Iniciar los servicios
```bash
docker compose up -d
```

### Detener los servicios
```bash
docker compose down
```

---

## 🔄 Descripción del Pipeline CI Implementado

El proyecto incluye un flujo de Integración Continua (CI) mediante **GitHub Actions** configurado en la carpeta `.github/workflows/`. Este pipeline automatiza las siguientes tareas en cada `push` o `pull_request` hacia la rama principal:

1. **Linting y Calidad de Código:** Analiza el código de Flutter (`flutter analyze`) y Node.js para asegurar las buenas prácticas.
2. **Ejecución de Pruebas:** Corre la suite de pruebas completas de Node.js (`npm test`) y Flutter (`flutter test`).
3. **Build de Verificación:** Compila el servidor en Docker y genera el build base de la aplicación para validar que no existan errores de integración.

---

## 🛠️ Principales Errores Encontrados y Solución Aplicada

### 1. Conflicto de CORS en la comunicación Frontend-Backend
* **Error:** La aplicación Flutter (en entorno Web/Emulador) no podía consumir la API del servidor local debido a restricciones de seguridad de origen cruzado (CORS).
* **Solución:** Se implementó el middleware `cors` en el archivo `server.js` de Node.js para permitir peticiones explícitas desde los dominios del emulador y el navegador local.

### 2. Error de conexión con el localhost desde el Emulador Android
* **Error:** El emulador de Android no lograba conectar con `http://localhost:3000`.
* **Solución:** Se sustituyó `localhost` por la IP especial del emulador de Android (`http://10.0.2.2:3000`) dentro de las configuraciones del entorno local en Flutter.

### 3. Dependencias desactualizadas en `pubspec.lock`
* **Error:** Errores de compilación al ejecutar `flutter pub get` por incompatibilidad de versiones de paquetes antiguos.
* **Solución:** Se ejecutó `flutter pub upgrade` para resolver los conflictos de dependencias del ecosistema de Flutter y fijar las versiones estables compatibles.
