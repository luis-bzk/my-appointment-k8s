# ------------------
# BUILD IMAGES
# ------------------

# Construye la imagen de la base de datos y la carga en Minikube
build-database:
	docker build -t postgres-local ../my-appointment-database/
	minikube image load postgres-local

# Construye la imagen del backend y la carga en Minikube
build-backend:
	docker build -t backend-local ../my-appointment-backend/
	minikube image load backend-local

# Construye ambas imágenes
build: build-database build-backend

# ------------------
# DEPLOY
# ------------------

# Despliega todo el stack (base de datos + backend + ingress)
deploy:
	kubectl apply -k overlays/dev/

# Despliega solo la base de datos (útil para testing individual)
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
