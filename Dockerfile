# 1. Usamos una versión ligera y estable de Node.js como base
FROM node:20-alpine

# 2. Definimos el directorio de trabajo dentro del contenedor
WORKDIR /app

# 3. Copiamos solo los archivos de dependencias para aprovechar la caché de Docker
COPY package*.json ./

# 4. Instalamos las dependencias de producción (evitamos instalar herramientas de desarrollo como Jest)
RUN npm ci --only=production

# 5. Copiamos el resto del código fuente del backend al contenedor
COPY . .

# 6. Exponemos el puerto en el que corre tu server.js (según tu terminal, el 3000)
EXPOSE 3000

# 7. Comando oficial para arrancar la aplicación en producción
CMD ["node", "server.js"]
