# Makefile para Nubrik - Sistema de gestión de citas
# Este Makefile simplifica las operaciones de desarrollo y producción

.PHONY: help dev prod stop clean build push logs restart db-only backend-only

# === VARIABLES ===
COMPOSE_DEV = docker-compose -f docker-compose.dev.yml
COMPOSE_PROD = docker-compose -f docker-compose.prod.yml
ENV_FILE = .env

# Colores para output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

# === COMANDOS PRINCIPALES ===

help: ## Muestra esta ayuda
	@echo "$(GREEN)=== COMANDOS DISPONIBLES PARA CITARY ===$(NC)"
	@echo ""
	@echo "$(YELLOW)DESARROLLO:$(NC)"
	@echo "  make dev            - Levantar ambiente completo de desarrollo"
	@echo "  make db-only        - Solo base de datos (para desarrollo con backend local)"
	@echo "  make backend-only   - Solo backend y base de datos"
	@echo "  make stop           - Detener todos los servicios"
	@echo "  make restart        - Reiniciar todos los servicios"
	@echo "  make logs           - Ver logs de todos los servicios"
	@echo "  make logs-backend   - Ver logs solo del backend"
	@echo "  make clean          - Limpiar todo (contenedores, volúmenes, imágenes)"
	@echo ""
	@echo "$(YELLOW)PRODUCCIÓN:$(NC)"
	@echo "  make build          - Construir imágenes de producción"
	@echo "  make push           - Subir imágenes a Docker Hub"
	@echo "  make prod           - Levantar en modo producción"
	@echo "  make prod-stop      - Detener servicios de producción"
	@echo ""
	@echo "$(YELLOW)UTILIDADES:$(NC)"
	@echo "  make setup          - Configurar ambiente inicial (.env)"
	@echo "  make validate       - Validar configuración"
	@echo "  make db-backup      - Backup de base de datos"
	@echo "  make db-restore     - Restaurar base de datos"
	@echo ""

# === DESARROLLO ===

setup: ## Configurar ambiente inicial
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(GREEN)Creando archivo .env desde template...$(NC)"; \
		cp .env.example .env; \
		echo "$(YELLOW)Por favor edita .env con tus valores reales$(NC)"; \
	else \
		echo "$(YELLOW)El archivo .env ya existe$(NC)"; \
	fi

validate: ## Validar configuración
	@echo "$(GREEN)Validando configuración...$(NC)"
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED)ERROR: No existe .env. Ejecuta 'make setup' primero$(NC)"; \
		exit 1; \
	fi
	@echo "Verificando proyectos..."
	@test -d ../nubrik-backend || (echo "$(RED)ERROR: No se encuentra nubrik-backend$(NC)" && exit 1)
	@test -d ../nubrik-frontend || (echo "$(RED)ERROR: No se encuentra nubrik-frontend$(NC)" && exit 1)
	@test -d ../nubrik-database || (echo "$(RED)ERROR: No se encuentra nubrik-database$(NC)" && exit 1)
	@echo "$(GREEN)✓ Configuración válida$(NC)"

dev: validate ## Levantar ambiente de desarrollo completo
	@echo "$(GREEN)Iniciando ambiente de desarrollo...$(NC)"
	$(COMPOSE_DEV) up -d
	@echo "$(GREEN)✓ Servicios iniciados:$(NC)"
	@echo "  - Frontend: http://localhost:5173"
	@echo "  - Backend:  http://localhost:3001"
	@echo "  - Database: localhost:5432"

db-only: validate ## Solo base de datos
	@echo "$(GREEN)Iniciando solo base de datos...$(NC)"
	$(COMPOSE_DEV) up -d database
	@echo "$(GREEN)✓ Base de datos disponible en localhost:5432$(NC)"

backend-only: validate ## Backend y base de datos
	@echo "$(GREEN)Iniciando backend y base de datos...$(NC)"
	$(COMPOSE_DEV) up -d database backend
	@echo "$(GREEN)✓ Backend disponible en http://localhost:3001$(NC)"

stop: ## Detener todos los servicios
	@echo "$(YELLOW)Deteniendo servicios...$(NC)"
	$(COMPOSE_DEV) down
	$(COMPOSE_PROD) down 2>/dev/null || true
	@echo "$(GREEN)✓ Servicios detenidos$(NC)"

restart: stop dev ## Reiniciar servicios de desarrollo

logs: ## Ver logs de todos los servicios
	$(COMPOSE_DEV) logs -f

logs-backend: ## Ver logs del backend
	$(COMPOSE_DEV) logs -f backend

logs-frontend: ## Ver logs del frontend
	$(COMPOSE_DEV) logs -f frontend

logs-db: ## Ver logs de la base de datos
	$(COMPOSE_DEV) logs -f database

# === PRODUCCIÓN ===

build: validate ## Construir imágenes de producción
	@echo "$(GREEN)Construyendo imágenes de producción...$(NC)"
	$(COMPOSE_PROD) build
	@echo "$(GREEN)✓ Imágenes construidas$(NC)"

build-no-cache: validate ## Construir sin cache
	@echo "$(GREEN)Construyendo imágenes sin cache...$(NC)"
	$(COMPOSE_PROD) build --no-cache
	@echo "$(GREEN)✓ Imágenes construidas$(NC)"

push: ## Subir imágenes a Docker Hub
	@echo "$(GREEN)Subiendo imágenes a Docker Hub...$(NC)"
	$(COMPOSE_PROD) push
	@echo "$(GREEN)✓ Imágenes subidas$(NC)"

prod: validate ## Levantar en modo producción
	@echo "$(GREEN)Iniciando ambiente de producción...$(NC)"
	$(COMPOSE_PROD) up -d
	@echo "$(GREEN)✓ Servicios en producción:$(NC)"
	@echo "  - Frontend: http://localhost"
	@echo "  - Backend:  http://localhost:3001"

prod-stop: ## Detener servicios de producción
	@echo "$(YELLOW)Deteniendo servicios de producción...$(NC)"
	$(COMPOSE_PROD) down
	@echo "$(GREEN)✓ Servicios detenidos$(NC)"

# === LIMPIEZA ===

clean: ## Limpiar todo (CUIDADO: borra datos)
	@echo "$(RED)ADVERTENCIA: Esto borrará todos los contenedores, volúmenes e imágenes$(NC)"
	@echo "Presiona Ctrl+C para cancelar o Enter para continuar..."
	@read dummy
	$(COMPOSE_DEV) down -v --rmi all
	$(COMPOSE_PROD) down -v --rmi all 2>/dev/null || true
	docker system prune -af
	@echo "$(GREEN)✓ Limpieza completa$(NC)"

clean-volumes: ## Limpiar solo volúmenes
	@echo "$(YELLOW)Limpiando volúmenes...$(NC)"
	$(COMPOSE_DEV) down -v
	$(COMPOSE_PROD) down -v 2>/dev/null || true
	@echo "$(GREEN)✓ Volúmenes eliminados$(NC)"

# === UTILIDADES ===

shell-backend: ## Abrir shell en el backend
	$(COMPOSE_DEV) exec backend sh

shell-frontend: ## Abrir shell en el frontend  
	$(COMPOSE_DEV) exec frontend sh

shell-db: ## Abrir psql en la base de datos
	$(COMPOSE_DEV) exec database psql -U root -d my_database_pg

db-backup: ## Backup de la base de datos
	@echo "$(GREEN)Creando backup de base de datos...$(NC)"
	@mkdir -p backups
	$(COMPOSE_DEV) exec -T database pg_dump -U root my_database_pg > backups/backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✓ Backup creado en backups/$(NC)"

db-restore: ## Restaurar base de datos desde backup
	@echo "$(YELLOW)Archivos de backup disponibles:$(NC)"
	@ls -1 backups/*.sql 2>/dev/null || echo "No hay backups disponibles"
	@echo ""
	@echo "Uso: make db-restore FILE=backups/backup_YYYYMMDD_HHMMSS.sql"

# Restaurar con archivo específico
ifdef FILE
	@echo "$(GREEN)Restaurando desde $(FILE)...$(NC)"
	$(COMPOSE_DEV) exec -T database psql -U root my_database_pg < $(FILE)
	@echo "$(GREEN)✓ Base de datos restaurada$(NC)"
endif

# === COMANDOS DE DESARROLLO ===

install-backend: ## Instalar dependencias del backend
	cd ../nubrik-backend && npm install

install-frontend: ## Instalar dependencias del frontend
	cd ../nubrik-frontend && npm install

test-backend: ## Ejecutar tests del backend
	$(COMPOSE_DEV) exec backend npm test

test-frontend: ## Ejecutar tests del frontend
	$(COMPOSE_DEV) exec frontend npm test

lint: ## Ejecutar linters
	@echo "$(GREEN)Ejecutando linters...$(NC)"
	cd ../nubrik-backend && npm run lint || true
	cd ../nubrik-frontend && npm run lint || true

# === MONITOREO ===

ps: ## Ver estado de los contenedores
	@docker-compose -f docker-compose.dev.yml ps
	@docker-compose -f docker-compose.prod.yml ps 2>/dev/null || true

stats: ## Ver estadísticas de recursos
	@docker stats --no-stream $$(docker-compose -f docker-compose.dev.yml ps -q 2>/dev/null)

# === DEPLOYMENT ===

deploy-script: ## Generar script de deployment
	@echo "$(GREEN)Generando script de deployment...$(NC)"
	@mkdir -p deploy
	@echo '#!/bin/bash' > deploy/deploy.sh
	@echo 'echo "Desplegando Nubrik..."' >> deploy/deploy.sh
	@echo 'docker-compose -f docker-compose.prod.yml pull' >> deploy/deploy.sh
	@echo 'docker-compose -f docker-compose.prod.yml up -d' >> deploy/deploy.sh
	@echo 'echo "✓ Deployment completado"' >> deploy/deploy.sh
	@chmod +x deploy/deploy.sh
	@echo "$(GREEN)✓ Script generado en deploy/deploy.sh$(NC)"