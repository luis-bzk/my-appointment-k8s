#!/bin/bash

set -e

NAMESPACE="${NAMESPACE:-citary}"
DRY_RUN="${DRY_RUN:-false}"

echo "🚀 Desplegando aplicación en Kubernetes..."

# Función para aplicar archivos YAML
apply_yaml() {
    local file=$1
    local description=$2
    
    echo "📝 Aplicando ${description}..."
    
    if [ "$DRY_RUN" = "true" ]; then
        kubectl apply -f "$file" --dry-run=client -o yaml
    else
        kubectl apply -f "$file"
    fi
}

# Crear namespace si no existe
echo "🏷️ Creando namespace ${NAMESPACE}..."
if [ "$DRY_RUN" = "true" ]; then
    kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml || true
else
    kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f - || true
fi

# Desplegar base de datos
echo "📊 Desplegando base de datos..."
apply_yaml "kubernetes/database/postgres-pvc.yaml" "PersistentVolumeClaim de PostgreSQL"
apply_yaml "kubernetes/database/postgres-deployment.yaml" "Deployment de PostgreSQL"
apply_yaml "kubernetes/database/postgres-service.yaml" "Service de PostgreSQL"

# Esperar a que la base de datos esté lista
if [ "$DRY_RUN" != "true" ]; then
    echo "⏳ Esperando a que PostgreSQL esté listo..."
    kubectl wait --for=condition=available --timeout=300s deployment/postgres-deployment -n "$NAMESPACE"
fi

# Desplegar backend
echo "⚙️ Desplegando backend..."
apply_yaml "kubernetes/backend/backend-deployment.yaml" "Deployment del Backend"
apply_yaml "kubernetes/backend/backend-service.yaml" "Service del Backend"
apply_yaml "kubernetes/backend/backend-hpa.yaml" "HPA del Backend"

# Esperar a que el backend esté listo
if [ "$DRY_RUN" != "true" ]; then
    echo "⏳ Esperando a que el Backend esté listo..."
    kubectl wait --for=condition=available --timeout=300s deployment/backend-deployment -n "$NAMESPACE"
fi

# Desplegar frontend
echo "🖥️ Desplegando frontend..."
apply_yaml "kubernetes/frontend/frontend-deployment.yaml" "Deployment del Frontend"
apply_yaml "kubernetes/frontend/frontend-service.yaml" "Service del Frontend"

# Desplegar ingress
echo "🌐 Desplegando ingress..."
apply_yaml "kubernetes/ingress/ingress.yaml" "Ingress"

# Verificar el estado final
if [ "$DRY_RUN" != "true" ]; then
    echo "✅ Despliegue completado. Verificando estado..."
    
    echo ""
    echo "📊 Estado de los pods:"
    kubectl get pods -n "$NAMESPACE"
    
    echo ""
    echo "🔗 Servicios disponibles:"
    kubectl get services -n "$NAMESPACE"
    
    echo ""
    echo "🌐 Ingress configurado:"
    kubectl get ingress -n "$NAMESPACE"
    
    echo ""
    echo "🎯 Para acceder a la aplicación:"
    echo "   Frontend: http://citary.local"
    echo "   Backend API: http://citary.local/api"
    echo ""
    echo "💡 Recuerda agregar 'citary.local' a tu /etc/hosts apuntando a tu cluster IP"
fi

echo "🎉 Despliegue finalizado exitosamente!"