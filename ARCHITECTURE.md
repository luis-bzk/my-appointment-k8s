# Arquitectura de Infraestructura - Nubrik

Este documento explica la arquitectura y estructura de archivos del proyecto de infraestructura.

## 📂 Estructura de Archivos

### docker-compose.dev.yml

**Propósito**: Configuración para desarrollo local con hot-reload y debugging.

**Características**:
- **Base de datos local**: PostgreSQL con persistencia de datos
- **Hot reload**: Volúmenes montados para código fuente
- **Variables de entorno**: Cargadas desde archivo `.env`
- **Health checks**: Para garantizar orden de inicio correcto
- **Networking**: Red bridge compartida entre servicios

**Servicios**:
1. **database**: PostgreSQL 15 con scripts de inicialización
2. **backend**: Node.js con nodemon para desarrollo
3. **frontend**: Vite dev server con HMR

### docker-compose.prod.yml

**Propósito**: Configuración optimizada para producción.

**Características**:
- **Sin base de datos**: Se asume uso de servicio administrado
- **Imágenes optimizadas**: Multi-stage builds
- **Health checks**: Para monitoreo y orquestadores
- **Restart policy**: `unless-stopped` para alta disponibilidad

**Notas importantes**:
- Frontend servido en puerto 80
- Backend mantiene su puerto configurado
- Imágenes publicadas en Docker Hub

### .env.example

**Propósito**: Template de configuración con todas las variables necesarias.

**Secciones**:
1. **General**: Puerto, nombre del sistema
2. **Seguridad**: JWT seed
3. **Base de datos**: Credenciales y conexión
4. **SMTP**: Configuración de correo
5. **OAuth**: Google authentication
6. **Docker Registry**: Para publicación de imágenes

### Makefile

**Propósito**: Simplificar operaciones comunes con comandos intuitivos.

**Categorías de comandos**:

1. **Desarrollo**
   - `make dev`: Inicio rápido completo
   - `make db-only`: Solo BD para desarrollo híbrido
   - `make logs-*`: Debugging y monitoreo

2. **Producción**
   - `make build`: Construcción de imágenes
   - `make push`: Publicación a registry
   - `make prod`: Despliegue production-ready

3. **Utilidades**
   - `make setup`: Configuración inicial
   - `make validate`: Verificación de prerequisitos
   - `make db-backup/restore`: Gestión de datos

4. **Mantenimiento**
   - `make clean`: Limpieza completa
   - `make shell-*`: Acceso a contenedores
   - `make stats`: Monitoreo de recursos

## 🏗️ Arquitectura

### Flujo de Desarrollo

```
Developer → make dev → docker-compose.dev.yml
                          ↓
                    ┌─────────────┐
                    │  Database   │
                    │ (PostgreSQL)│
                    └─────────────┘
                          ↑
                    ┌─────────────┐
                    │   Backend   │ ← Hot reload
                    │  (Node.js)  │
                    └─────────────┘
                          ↑
                    ┌─────────────┐
                    │  Frontend   │ ← HMR
                    │   (React)   │
                    └─────────────┘
```

### Flujo de Producción

```
CI/CD → make build → Docker Hub
                        ↓
                 ┌──────────────┐
                 │Cloud Provider│
                 └──────────────┘
                        ↓
              ┌─────────────────────┐
              │   Load Balancer    │
              └─────────────────────┘
                    ↓         ↓
            ┌─────────────┐ ┌─────────────┐
            │  Frontend   │ │   Backend   │
            │  (Static)   │ │    (API)    │
            └─────────────┘ └─────────────┘
                                  ↓
                            ┌─────────────┐
                            │  Database   │
                            │  (Managed)  │
                            └─────────────┘
```

## 🔐 Seguridad

### Variables de Entorno

- **Desarrollo**: Archivo `.env` local (no versionado)
- **Producción**: Variables inyectadas por el orquestador
- **Secrets**: Usar servicios de gestión de secretos en producción

### Networking

- **Desarrollo**: Red bridge aislada
- **Producción**: Configurar según proveedor cloud
- **Exposición**: Solo exponer puertos necesarios

## 🚀 Estrategias de Despliegue

### Opción 1: Servidor Simple (VPS)

```bash
# En el servidor
docker-compose -f docker-compose.prod.yml up -d
```

### Opción 2: Container Services

- **Google Cloud Run**: Serverless, escala a cero
- **AWS ECS/Fargate**: Orquestación administrada
- **Azure Container Instances**: Despliegue rápido

### Opción 3: Kubernetes

Para proyectos que requieran mayor control y escalabilidad.

## 📊 Monitoreo Recomendado

1. **Logs**: Centralizar con ELK Stack o servicios cloud
2. **Métricas**: Prometheus + Grafana o servicios administrados
3. **Alertas**: Configurar para disponibilidad y rendimiento
4. **Backups**: Automatizar para base de datos

## 🔄 Ciclo de Vida

### Desarrollo
1. `make setup` - Configuración inicial
2. `make dev` - Desarrollo iterativo
3. `make test-*` - Pruebas
4. `make build` - Preparar para producción

### Producción
1. `make build` - Construir imágenes
2. `make push` - Publicar a registry
3. Deploy según plataforma
4. Monitoreo continuo

## 💡 Mejores Prácticas

1. **Versionado**: Usar tags semánticos para imágenes
2. **Configuración**: Externalizar toda config sensible
3. **Logs**: Estructurados (JSON) para mejor análisis
4. **Health checks**: Implementar endpoints dedicados
5. **Graceful shutdown**: Manejar señales correctamente