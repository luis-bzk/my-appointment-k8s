# Citary Infrastructure

Orquestación completa para la aplicación Citary con Docker Compose y Kubernetes.

## 📋 Tabla de Contenidos

- [Prerequisitos](#prerequisitos)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Configuración Inicial](#configuración-inicial)
- [Desarrollo Local](#desarrollo-local)
- [Producción](#producción)
- [Kubernetes](#kubernetes)
- [CI/CD](#cicd)
- [Troubleshooting](#troubleshooting)

## 🔧 Prerequisitos

### Software Requerido
- **Docker** >= 20.10
- **Docker Compose** >= 2.0
- **Kubernetes** (Docker Desktop, Minikube, o cluster)
- **kubectl** 
- **Make** (opcional pero recomendado)
- **Git**

### Verificar Instalación
```bash
docker --version
docker-compose --version
kubectl version --client
make --version
```

## 📁 Estructura del Proyecto

```
citary-infra/
├── docker/
│   ├── docker-compose.yml         
│   ├── docker-compose.dev.yml   
│   ├── docker-compose.prod.yml  
│   └── .env.example     
├── kubernetes/
│   ├── namespace.yaml
│   ├── database/
│   ├── backend/
│   ├── frontend/
│   └── ingress/
├── scripts/
│   ├── build-images.sh
│   ├── deploy-k8s.sh
│   └── cleanup.sh
├── Makefile
└── README.md
```

## ⚙️ Configuración Inicial

### 1. Clonar Repositorio de Infraestructura
```bash
git clone https://github.com/tu-usuario/citary-infra.git
cd citary-infra
```

### 2. Configurar Variables de Entorno
```bash
cp docker/.env.example docker/.env
```

Edita `docker/.env`:
```env
# GitHub Configuration
GITHUB_USER=tu-usuario-github
GITHUB_TOKEN=ghp_xxxxxxxxxxxx  # Solo para repos privados

# Registry Configuration  
REGISTRY=tu-usuario  # Docker Hub username o registry URL
TAG=latest

# Database Configuration
POSTGRES_USER=root
POSTGRES_PASSWORD=tu-password-seguro
POSTGRES_DB=my_database_pg

# API Configuration
VITE_API_URL=http://localhost:3000
```

### 3. Para Desarrollo Local - Clonar Repositorios
```bash
# Solo necesario para desarrollo local
mkdir repos
cd repos

# Clonar repositorios (ajusta las URLs)
git clone https://github.com/tu-usuario/citary-backend.git
git clone https://github.com/tu-usuario/citary-frontend.git  
git clone https://github.com/tu-usuario/citary-database.git

cd ..
```

## 🚀 Desarrollo Local

### Opción A: Con Repositorios Locales (Recomendado para desarrollo)

```bash
# Levantar todo en modo desarrollo
make up-dev

# O manualmente
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.dev.yml up -d
```

### Opción B: Desde GitHub (Para testing)

```bash
# Levantar todo desde GitHub  
make up

# Solo base de datos
make up-db

# Base + Backend
make up-backend
```

### Comandos Útiles de Desarrollo

```bash
# Ver logs en tiempo real
make logs

# Ver logs específicos
make logs-backend

# Reiniciar servicios
docker-compose restart backend

# Ejecutar comandos en contenedores
docker-compose exec backend npm run test
docker-compose exec database psql -U root -d my_database_pg
```

### Acceso a la Aplicación

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:3000  
- **Base de Datos**: localhost:5432

## 🏭 Producción

### 1. Construir y Subir Imágenes

```bash
# Construir todas las imágenes
make build

# Construir y subir al registry
make build-push

# Manualmente con variables específicas
REGISTRY=tu-usuario TAG=v1.0.0 make build-push
```

### 2. Desplegar en Producción

```bash
# Levantar en modo producción
make up-prod

# Con réplicas específicas
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.prod.yml up -d --scale backend=3
```

## ☸️ Kubernetes

### 1. Preparar Cluster

```bash
# Para Docker Desktop
kubectl config use-context docker-desktop

# Para Minikube  
minikube start
kubectl config use-context minikube

# Verificar conexión
kubectl cluster-info
```

### 2. Instalar NGINX Ingress Controller

```bash
# Para Docker Desktop
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml

# Para Minikube
minikube addons enable ingress
```

### 3. Construir y Subir Imágenes

```bash
# Construir imágenes para Kubernetes
make build-images

# Subir al registry
PUSH=true make build-images
```

### 4. Desplegar en Kubernetes

```bash
# Despliegue completo
make deploy-k8s

# Ver qué se va a desplegar (dry-run)
make deploy-k8s-dry

# Verificar estado
make status-k8s
```

### 5. Configurar Acceso Local

Agregar a `/etc/hosts` (Linux/Mac) o `C:\Windows\System32\drivers\etc\hosts` (Windows):
```
127.0.0.1 citary.local
```

### 6. Acceso a la Aplicación

- **Frontend**: http://citary.local
- **Backend API**: http://citary.local/api

### 7. Comandos de Kubernetes

```bash
# Escalar backend
make scale-backend REPLICAS=5

# Ver logs
make logs-k8s
make logs-k8s-backend

# Reiniciar deployments
make restart-backend
make restart-frontend

# Limpiar todo
make delete-k8s
```

## 🔄 CI/CD

### Configuración con GitHub Actions

Crear `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: ghcr.io
  GITHUB_USER: ${{ github.actor }}

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Log in to Container Registry
      uses: docker/login-action@v2
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Build and push images
      run: |
        REGISTRY=${{ env.REGISTRY }}/${{ env.GITHUB_USER }} \
        TAG=${{ github.sha }} \
        PUSH=true \
        ./scripts/build-images.sh

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v3
    
    - name: Configure kubectl
      uses: azure/setup-kubectl@v3
    
    - name: Deploy to Kubernetes
      run: |
        sed -i "s/:latest/:${{ github.sha }}/g" kubernetes/*/**.yaml
        kubectl apply -f kubernetes/
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    
    environment {
        REGISTRY = 'tu-registry'
        GITHUB_USER = 'tu-usuario'
        TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Build Images') {
            steps {
                sh './scripts/build-images.sh'
            }
        }
        
        stage('Push Images') {
            steps {
                sh 'PUSH=true ./scripts/build-images.sh'
            }
        }
        
        stage('Deploy to K8s') {
            when {
                branch 'main'
            }
            steps {
                sh './scripts/deploy-k8s.sh'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
```

## 🛠️ Troubleshooting

### Problemas Comunes

#### Docker Compose no encuentra repositorios privados
```bash
# Usar token de GitHub
export GITHUB_TOKEN=ghp_xxxxxxxxxxxx

# O usar contexto local para desarrollo
make up-dev  # En lugar de make up
```

#### Backend no se conecta a la base de datos
```bash
# Verificar que la base esté corriendo
docker-compose ps

# Ver logs de la base
docker-compose logs database

# Verificar conectividad
docker-compose exec backend nc -z database 5432
```

#### Frontend no puede conectar con el backend
```bash
# Verificar variables de entorno
docker-compose exec frontend env | grep VITE_API_URL

# Reconstruir con la URL correcta
VITE_API_URL=http://localhost:3000 docker-compose up --build frontend
```

#### Kubernetes pods en estado Pending
```bash
# Verificar recursos del cluster
kubectl describe nodes

# Verificar PVC
kubectl get pvc -n citary

# Ver eventos
kubectl get events -n citary --sort-by='.lastTimestamp'
```

#### Ingress no funciona
```bash
# Verificar que ingress controller esté corriendo
kubectl get pods -n ingress-nginx

# Verificar servicios
kubectl get services -n citary

# Verificar ingress
kubectl describe ingress citary-ingress -n citary
```

### Comandos de Diagnóstico

```bash
# Docker
docker system df  # Ver uso de espacio
docker system prune  # Limpiar recursos no usados

# Kubernetes  
kubectl get all -n citary  # Ver todos los recursos
kubectl top pods -n citary  # Ver uso de recursos
kubectl describe pod <pod-name> -n citary  # Detalles de pod específico
```

### Logs Útiles

```bash
# Docker Compose
docker-compose logs --tail=100 -f

# Kubernetes
kubectl logs -f deployment/backend-deployment -n citary
kubectl logs --previous -c backend <pod-name> -n citary  # Logs anteriores
```

## 📞 Soporte

Si encuentras problemas:

1. **Revisa los logs** usando los comandos de arriba
2. **Verifica la configuración** en los archivos `.env`
3. **Consulta la documentación** de Docker/Kubernetes
4. **Abre un issue** en el repositorio con:
   - Descripción del problema
   - Logs relevantes
   - Pasos para reproducir
   - Información del entorno

## 🤝 Contribución

1. Fork el repositorio
2. Crea una rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.