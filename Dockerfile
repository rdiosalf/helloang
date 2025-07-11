# === Fase 1: Construcción (Build) ===
# Utilizamos una imagen de Node para compilar la aplicación Angular
FROM node:18-alpine AS build

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar package.json y package-lock.json para instalar dependencias primero
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto de los archivos de la aplicación
COPY . .

# Construir la aplicación Angular en modo producción (optimizado)
RUN npm run build -- --output-path=./dist/out --configuration=production

# === Fase 2: Servir la Aplicación (Serve) ===
# Utilizamos una imagen de Nginx ligera para servir la aplicación estática
FROM nginx:alpine

# Copiar la configuración de Nginx (si es necesario, para SPA)
# Opcional: crea un archivo nginx.conf si tu app requiere manejo de rutas SPA
# COPY nginx.conf /etc/nginx/nginx.conf

# Copiar los archivos estáticos generados en la fase de construcción al directorio de Nginx
# La carpeta 'out' es la que usamos en el paso de npm run build
COPY --from=build /app/dist/out/browser /usr/share/nginx/html

# Exponer el puerto por defecto de Nginx
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]