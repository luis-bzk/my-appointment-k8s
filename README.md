
# My Appointment Application - Kubernetes Deployment (Local Development)

This directory contains the Kubernetes deployment configuration for the My Appointment application, optimized for local development.

## ⚠️ SUPER IMPORTANT: Required Repositories

Before running any `make` or deployment commands, ensure you have **cloned all the required repositories** into the correct relative paths. For now, you must have:

- [`my-appointment-database`](../my-appointment-database/)
- [`my-appointment-backend`](../my-appointment-backend/)

> 🧩 In the future, additional services may be added to the application architecture. Make sure all repositories are properly cloned and available for Docker builds and deployments to work correctly.

---

## 🧠 Heads-Up: Development with Persistent Volumes

Kubernetes **Persistent Volumes (PVs)** store your PostgreSQL data between restarts.  
⚠️ This means if you update your SQL files (like `core.sql`) **the changes won’t apply unless you reset the volume**.

To wipe the volume and reapply migrations from scratch:

```bash
# 1. Delete pod
kubectl delete deployment postgres --ignore-not-found

# 2. Delete PVC and PV
kubectl delete pvc postgres-pvc --ignore-not-found
kubectl delete pv postgres-pv --ignore-not-found

# 3. Build
make build-database

# 4. Deploy
make deploy-database
```

> 🧽 This fully cleans up the volume so all migrations and seeds from `/docker-entrypoint-initdb.d/` are re-executed.

---

## 🛠️ Prerequisites

1. **Kubernetes Environment**
   - Minikube
   - kubectl
   - Docker (for building and loading local images)

2. **Required Tools**
   - `make` (for running automation commands)

   ### Installing Make

   #### Linux
   ```bash
   sudo apt update && sudo apt install -y make
   ```

   #### Windows (with Chocolatey)
   ```powershell
   choco install make
   ```

3. **System Requirements**
   - 32GB RAM recommended
   - 6+ CPU cores
   - 10GB+ free disk space

---

## 🚀 Initial Setup

### 1. Start Minikube
```bash
minikube start
```

### 2. Enable Ingress (Optional)
```bash
minikube addons enable ingress
```

### 3. Add Local DNS Entry
Edit your hosts file:

**Linux/macOS:** `/etc/hosts`  
**Windows:** `C:\Windows\System32\drivers\etc\hosts`

Add:
```bash
127.0.0.1 my_appointment_backend.local
```

---

## 📦 Building Images

Run the following commands using `make`:

```bash
make build-database     # Build PostgreSQL image and load to Minikube
make build-backend      # Build backend image and load to Minikube
```

These targets perform two steps:
- Build a Docker image with a local `Dockerfile`
- Load the image into Minikube so Kubernetes can use it

---

## 🚢 Deploying the Application

### Deploy Everything (Database + Backend + Services)
```bash
make deploy
```

### Restart Everything
```bash
make restart
```

### Deploy Only the Database
```bash
make deploy-database
```

### Restart Only the Database
```bash
make restart-database
```

---

## 🔍 Verifying Deployment

```bash
make status            # Shows all deployed resources
kubectl get pods       # See pod status
kubectl get svc        # View service info
kubectl get pvc        # View persistent volume claims
```

---

## 🧹 Cleanup & Reset

### Remove All Kubernetes Resources
```bash
make delete
```

### Remove and Reset Database Volume
```bash
make reset-db
```

This is useful if you want to delete all persistent data stored by PostgreSQL.

---

## 🐘 Connect to PostgreSQL

### Port-forward to Access DB Locally
```bash
kubectl port-forward service/postgres 5432:5432
```

### Access with psql
```bash
kubectl exec -it deployment/postgres -- psql -U root -d my_database_pg
```

---

## 🔧 Utilities

```bash
make logs-db           # View logs for DB
make logs-backend      # View logs for backend
make status            # View all cluster resources
```

---

## 🌐 Access the App

Once deployed, visit:
```
http://my_appointment_backend.local/
```

---

## 🧱 Architecture Overview

### 1. Database (PostgreSQL)
- Persistent storage: 2GB
- CPU limits: 0.5 (min), 1 (max)
- Memory limits: 512Mi (min), 1Gi (max)
- Service port: 5432

### 2. Backend (Node.js)
- CPU limits: 0.25 (min), 0.5 (max)
- Memory limits: 256Mi (min), 512Mi (max)
- Exposed via Ingress on port 3000

### 3. Ingress Controller (Optional)
- Route traffic to backend using domain `my_appointment_backend.local`

---

## ⚙️ Makefile Targets Summary

```bash
make build-database         # Build DB image + load to Minikube
make build-backend          # Build backend image + load to Minikube
make deploy                 # Deploy all components (via Kustomize overlay)
make deploy-database        # Deploy only the database (PV, deployment, service)
make restart                # Delete & re-deploy everything
make restart-database       # Delete & re-deploy only DB
make delete                 # Delete entire deployment overlay
make reset-db               # Delete DB volumes (PVC and PV)
make logs-db                # View logs for DB deployment
make logs-backend           # View logs for backend deployment
make status                 # View cluster resources (pods, services, PVCs, etc.)
```

---

## 🧠 Troubleshooting

### Image Issues
- If pod status shows `ImagePullBackOff`, the image might not have been loaded into Minikube.
- Run:
```bash
minikube image list
```
- If not present, rebuild:
```bash
make build-database
```

### Pod Issues
```bash
kubectl describe pod <pod-name>   # View events/errors
kubectl logs <pod-name>           # View logs
```

### Monitoring
```bash
kubectl top pods
kubectl top nodes
```

---

✅ All workflows are automated with `make`. No need for manual Docker context switching or scripts.

> Happy hacking with My Appointment! 🚀
