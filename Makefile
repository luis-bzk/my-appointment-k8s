# ------------------
# BUILD IMAGES
# ------------------

# Construye la imagen de la base de datos
build-database:
	docker build -t postgres-local ../citary-database/

# Construye la imagen del backend
build-backend:
	docker build -t backend-local ../citary-backend/

# Construye ambas imágenes
build: build-database build-backend

# ------------------
# DEPLOY
# ------------------

# Despliega todo el stack (base de datos + backend + ingress)
deploy:
	kubectl apply -k overlays/dev/
	kubectl apply -f ingress/ingress.yaml

# Despliega solo la base de datos
deploy-database:
	kubectl apply -f base/postgres/persistent-volume.yaml
	kubectl apply -f base/postgres/deployment.yaml
	kubectl apply -f base/postgres/service.yaml

# ------------------
# DELETE / RESTART
# ------------------

# Elimina todo el stack
delete:
	kubectl delete -k overlays/dev/ --ignore-not-found
	kubectl delete -f ingress/ingress.yaml --ignore-not-found

# Reinicia todo el stack (delete + deploy)
restart:
	$(MAKE) delete
	$(MAKE) deploy

# Reinicia solo la base de datos
restart-database:
	kubectl delete -f base/postgres/ --ignore-not-found
	kubectl apply -f base/postgres/

# Elimina volúmenes persistentes de la base de datos (⚠️ borra datos)
reset-db:
	kubectl delete pvc postgres-pvc --ignore-not-found
	kubectl delete pv postgres-pv --ignore-not-found

# ------------------
# UTILS
# ------------------

# Muestra logs de la base de datos
logs-db:
	kubectl logs deployment/postgres

# Muestra logs del backend
logs-backend:
	kubectl logs deployment/backend

# Muestra el estado de todos los recursos en el namespace actual
status:
	kubectl get all

# Verifica los pods, servicios, ingress y PVCs
diagnose:
	kubectl get pods
	kubectl get svc
	kubectl get ingress
	kubectl get pvc

# Describe un pod específico (ej. make describe pod=postgres-xyz)
describe:
	kubectl describe pod $(pod)
