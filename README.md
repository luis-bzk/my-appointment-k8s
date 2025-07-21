# Citary - Infraestructura y Orquestación

Este repositorio contiene toda la configuración de infraestructura para el sistema Citary, un sistema de gestión de citas médicas.

## 📁 Estructura del Proyecto

```
citary-appointment-k8s/
├── docker-compose.dev.yml    # Configuración para desarrollo local
├── docker-compose.prod.yml   # Configuración para producción
├── .env.example             # Template de variables de entorno
├── .env                     # Variables de entorno (no commitear)
├── Makefile                 # Comandos simplificados
├── README.md                # Este archivo
└── backup/                  # Respaldo de configuración anterior
```

### Proyectos Relacionados

Este repositorio orquesta tres proyectos independientes:

- **citary-backend**: API REST en Node.js
- **citary-frontend**: Aplicación web en React/Vite
- **citary-database**: PostgreSQL con scripts de inicialización

## 🚀 Inicio Rápido

### 1. Prerequisitos

- Docker y Docker Compose instalados
- Los tres repositorios clonados en el mismo nivel:
  ```
  /tu-directorio/
  ├── citary-appointment-k8s/
  ├── citary-backend/
  ├── citary-frontend/
  └── citary-database/
  ```

### 2. Configuración Inicial

```bash
# Configurar variables de entorno
make setup

# Editar .env con tus valores reales
nano .env
```

### 3. Desarrollo Local

```bash
# Levantar todos los servicios
make dev

# Solo base de datos (para desarrollo con backend local)
make db-only

# Ver logs
make logs
make logs-backend
```

### 4. URLs de Desarrollo

- Frontend: http://localhost:5173
- Backend: http://localhost:3001
- Database: localhost:5432

## 📋 Comandos Disponibles

### Desarrollo

| Comando | Descripción |
|---------|-------------|
| `make dev` | Levantar ambiente completo de desarrollo |
| `make db-only` | Solo base de datos |
| `make backend-only` | Solo backend y base de datos |
| `make stop` | Detener todos los servicios |
| `make restart` | Reiniciar servicios |
| `make logs` | Ver logs de todos los servicios |
| `make logs-backend` | Ver logs del backend |
| `make clean` | Limpiar todo (⚠️ borra datos) |

### Producción

| Comando | Descripción |
|---------|-------------|
| `make build` | Construir imágenes de producción |
| `make push` | Subir imágenes a Docker Hub |
| `make prod` | Levantar en modo producción |
| `make prod-stop` | Detener servicios de producción |

### Utilidades

| Comando | Descripción |
|---------|-------------|
| `make setup` | Configurar ambiente inicial |
| `make validate` | Validar configuración |
| `make db-backup` | Backup de base de datos |
| `make db-restore FILE=backup.sql` | Restaurar base de datos |
| `make shell-backend` | Abrir shell en backend |
| `make shell-db` | Abrir psql |

## 🔧 Configuración

### Variables de Entorno

El archivo `.env` contiene toda la configuración necesaria:

```env
# Puerto del backend
PORT=3001

# Base de datos
DB_HOST=database  # En producción: usar host real
DB_USER=root
DB_PASSWORD=root
DB_DATABASE=my_database_pg

# JWT y seguridad
JWT_SEED=your-secret-jwt-seed

# SMTP para correos
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Google OAuth (opcional)
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-secret
```

### Docker Compose

#### Desarrollo (`docker-compose.dev.yml`)
- Hot reload activado
- Volúmenes para código fuente
- Base de datos local
- Sin optimizaciones de producción

#### Producción (`docker-compose.prod.yml`)
- Imágenes optimizadas
- Health checks configurados
- Sin base de datos (usar servicio externo)
- Frontend servido con servidor estático

## 🚢 Despliegue

### Docker Hub

Las imágenes se publican en Docker Hub:
- `luisberrezueta/citary-backend:latest`
- `luisberrezueta/citary-frontend:latest`

```bash
# Construir y publicar
make build
make push
```

### Cloud Providers

#### Google Cloud Run

```bash
# Desplegar backend
gcloud run deploy citary-backend \
  --image luisberrezueta/citary-backend:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated

# Desplegar frontend
gcloud run deploy citary-frontend \
  --image luisberrezueta/citary-frontend:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

#### AWS ECS

1. Crear un cluster ECS
2. Definir task definitions con las imágenes
3. Crear servicios para backend y frontend
4. Configurar Application Load Balancer

#### Servidor VPS

```bash
# En el servidor
git clone https://github.com/tu-usuario/citary-appointment-k8s.git
cd citary-appointment-k8s

# Configurar .env
cp .env.example .env
nano .env

# Levantar servicios
docker-compose -f docker-compose.prod.yml up -d
```

## 🔄 CI/CD

### GitHub Actions (Ejemplo)

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Build and push
        run: |
          docker build -t ${{ secrets.DOCKER_REGISTRY }}/citary-backend ../citary-backend
          docker push ${{ secrets.DOCKER_REGISTRY }}/citary-backend
          
      - name: Deploy to server
        run: |
          ssh ${{ secrets.SERVER }} "cd citary && docker-compose pull && docker-compose up -d"
```

## 🛠️ Desarrollo

### Agregar nuevas variables de entorno

1. Actualizar `.env.example`
2. Actualizar `docker-compose.dev.yml` y `docker-compose.prod.yml`
3. Documentar en este README

### Debugging

```bash
# Ver estado de contenedores
make ps

# Ver uso de recursos
make stats

# Entrar a un contenedor
make shell-backend
make shell-frontend
make shell-db
```

## 📝 Notas Importantes

1. **Seguridad**: Nunca commitear el archivo `.env`
2. **Base de datos**: En producción, usar un servicio administrado (RDS, Cloud SQL, etc.)
3. **Backups**: Configurar backups automáticos en producción
4. **Monitoreo**: Implementar logs centralizados y métricas

## 🤝 Contribuir

1. Fork el proyecto
2. Crear una rama (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT.