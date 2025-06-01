.PHONY: help build up down logs clean build-prod up-prod down-prod deploy-k8s delete-k8s status-k8s logs-k8s up-local-db up-remote-services scale-backend logs-k8s-backend logs-k8s-frontend restart-backend restart-frontend

help:
	@echo "=== COMANDOS DISPONIBLES ==="
	@echo ""
	@echo "DESARROLLO LOCAL:"
	@echo "  build          - Construir todas las imagenes para desarrollo"
	@echo "  up             - Levantar todos los servicios en desarrollo"
	@echo "  up-db          - Levantar solo la base de datos"
	@echo "  up-backend     - Levantar base de datos y backend"
	@echo "  up-dev         - Levantar en modo desarrollo con hot reload"
	@echo "  down           - Bajar todos los servicios"
	@echo "  logs           - Ver logs de todos los servicios"
	@echo "  logs-backend   - Ver logs del backend"
	@echo "  clean          - Limpiar contenedores e imagenes"
	@echo ""
	@echo "PRODUCCION:"
	@echo "  build-prod     - Construir imagenes para produccion"
	@echo "  up-prod        - Levantar en modo produccion"
	@echo "  down-prod      - Bajar servicios de produccion"
	@echo ""
	@echo "KUBERNETES:"
	@echo "  deploy-k8s     - Desplegar en Kubernetes"
	@echo "  delete-k8s     - Eliminar deployment de Kubernetes"
	@echo "  status-k8s     - Ver estatus de pods"
	@echo "  logs-k8s       - Ver logs de todos los pods"
	@echo "  logs-k8s-backend - Ver logs especificos del backend"
	@echo "  logs-k8s-frontend - Ver logs especificos del frontend"
	@echo "  scale-backend  - Escalar backend (uso: make scale-backend REPLICAS=5)"
	@echo "  restart-backend - Reiniciar deployment del backend"
	@echo "  restart-frontend - Reiniciar deployment del frontend"
	@echo ""
	@echo "COMANDOS HIBRIDOS:"
	@echo "  up-local-db    - Solo base de datos local"
	@echo "  up-remote-services - Backend y frontend desde repositorios remotos"

# Comandos para desarrollo local (usa archivos locales)
build:
	cd docker && docker-compose build

up:
	cd docker && docker-compose up -d

up-db:
	cd docker && docker-compose up -d database

up-backend:
	cd docker && docker-compose up -d database backend

up-dev:
	cd docker && docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d

down:
	cd docker && docker-compose down

logs:
	cd docker && docker-compose logs -f

logs-backend:
	cd docker && docker-compose logs -f backend

clean:
	cd docker && docker-compose down -v --rmi all

# Comandos para produccion (usa repositorios remotos)
build-prod:
	cd docker && docker-compose -f docker-compose.yml -f docker-compose.prod.yml build

up-prod:
	cd docker && docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

down-prod:
	cd docker && docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

# Comandos para Kubernetes
deploy-k8s:
	./scripts/deploy-k8s.sh

deploy-k8s-dry:
	DRY_RUN=true ./scripts/deploy-k8s.sh

delete-k8s:
	./scripts/cleanup.sh

delete-k8s-force:
	FORCE=true ./scripts/cleanup.sh

status-k8s:
	kubectl get pods -n citary

scale-backend:
	kubectl scale deployment backend-deployment --replicas=$(REPLICAS) -n citary

logs-k8s:
	kubectl logs -l app=backend -n citary --tail=100 -f

logs-k8s-backend:
	kubectl logs -l app=backend -n citary --tail=100 -f

logs-k8s-frontend:
	kubectl logs -l app=frontend -n citary --tail=100 -f

restart-backend:
	kubectl rollout restart deployment/backend-deployment -n citary

restart-frontend:
	kubectl rollout restart deployment/frontend-deployment -n citary

# Comandos hibridos
up-local-db:
	cd docker && docker-compose up -d database

up-remote-services:
	cd docker && docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d backend frontend