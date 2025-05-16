# My Appointment Application – Kubernetes Deployment (Local Development)

Este directorio contiene la configuración de Kubernetes para desplegar la aplicación **My Appointment** localmente usando **Kubernetes en Docker Desktop**.

---

## 📦 Repositorios requeridos

Antes de ejecutar cualquier comando `make` o `kubectl`, asegurate de tener estos repos clonados correctamente (relativos al repositorio de Kubernetes):

* [`citary-database`](../citary-database/)
* [`citary-backend`](../citary-backend/)

---

## ⚙️ Requisitos

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) (con Kubernetes habilitado)
* [`kubectl`](https://kubernetes.io/docs/tasks/tools/)
* [`make`](https://www.gnu.org/software/make/) (Linux/macOS) o vía [Chocolatey](https://chocolatey.org/) en Windows

---

## 💪 Preparación del entorno

### 1. Habilitar Kubernetes en Docker Desktop

Desde la interfaz de Docker Desktop:

* Ve a **Settings > Kubernetes**
* Activa **"Enable Kubernetes"**
* Espera a que el clúster se inicialice (hasta que el ícono de Kubernetes tenga una tilde verde)

### 2. Agregar entrada en el archivo `/etc/hosts`

Para que Ingress funcione con dominios personalizados:

```bash
127.0.0.1 citary.local
```

Ubicación del archivo:

* **Linux/macOS:** `/etc/hosts`
* **Windows:** `C:\Windows\System32\drivers\etc\hosts`

### 3. Instalar un Ingress Controller (si aún no lo hiciste)

Si tu clúster no tiene un controlador NGINX:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/cloud/deploy.yaml
```

---

## 🧱 Estructura de los manifiestos

```txt
k8s/
├── base/
│   ├── backend/
│   └── postgres/
├── ingress/
├── overlays/
│   └── dev/
├── Makefile
└── README.md
```

---

## 🚀 Primer despliegue

### 1. Construir imágenes Docker locales

```bash
make build            # Construye backend + base de datos
```

### 2. Desplegar todo el stack

```bash
make deploy           # Aplica la configuración (base de datos + backend + ingress)
```

### 3. Ver estado

```bash
make status
```

---

## 🌐 Acceder a la aplicación

Una vez desplegada:

```bash
http://citary.local/
```

> Asegurate de tener el host configurado correctamente (ver paso anterior).

---

## 🐘 Acceso a PostgreSQL

### 1. Port-forward para conexión local

```bash
kubectl port-forward service/postgres 5432:5432
```

### 2. Acceder vía `psql`

```bash
kubectl exec -it deployment/postgres -- psql -U root -d my_database_pg
```

---

## 🔁 Reinicios y limpieza

### Reiniciar todo el stack

```bash
make restart
```

### Eliminar todos los recursos

```bash
make delete
```

### Reiniciar solo la base de datos

```bash
make restart-database
```

### Resetear volumen de la base de datos (⚠️ borra todos los datos)

```bash
make reset-db
```

---

## 📋 Comandos útiles

```bash
make logs-db           # Ver logs de Postgres
make logs-backend      # Ver logs del backend
make status            # Estado del clúster (pods, servicios, PVCs, etc.)
```

---

## 📊 Monitoreo y depuración

```bash
kubectl get pods
kubectl describe pod <nombre>
kubectl logs <nombre>
kubectl get svc
kubectl get pvc
kubectl top pods
kubectl top nodes
```

---

## 🤖 Arquitectura general

### PostgreSQL

* Volumen persistente: 2GB
* CPU: 0.5–1
* RAM: 512Mi–1Gi
* Puerto: 5432

### Backend (Node.js)

* CPU: 0.25–0.5
* RAM: 256Mi–512Mi
* Expuesto vía Ingress en puerto 3000

### Ingress Controller (opcional)

* Requiere configuración previa en Docker Desktop o mediante manifiesto externo

---

> ✅ Todos los flujos están automatizados con `make`. No se requieren scripts manuales ni cambios de contexto Docker.

✨ ¡Feliz desarrollo con My Appointment! 🚀
