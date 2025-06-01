#!/bin/bash

set -e

NAMESPACE="${NAMESPACE:-citary}"
FORCE="${FORCE:-false}"

echo "🧹 Limpiando recursos de Kubernetes..."

# Confirmación de seguridad
if [ "$FORCE" != "true" ]; then
    echo "⚠️  Esta operación eliminará todos los recursos del namespace '${NAMESPACE}'"
    echo "   Esto incluye:"
    echo "   - Todos los deployments y pods"
    echo "   - Todos los servicios"
    echo "   - Todos los PVCs y datos de la base de datos"
    echo "   - El ingress"
    echo ""
    read -p "¿Estás seguro? (escribe 'yes' para continuar): " confirm
    
    if [ "$confirm" != "yes" ]; then
        echo "❌ Operación cancelada"
        exit 0
    fi
fi

echo "🗑️ Eliminando recursos..."

# Eliminar ingress primero
echo "🌐 Eliminando ingress..."
kubectl delete -f kubernetes/ingress/ -n "$NAMESPACE" --ignore-not-found=true

# Eliminar frontend
echo "🖥️ Eliminando frontend..."
kubectl delete -f kubernetes/frontend/ -n "$NAMESPACE" --ignore-not-found=true

# Eliminar backend
echo "⚙️ Eliminando backend..."
kubectl delete -f kubernetes/backend/ -n "$NAMESPACE" --ignore-not-found=true

# Eliminar base de datos
echo "📊 Eliminando base de datos..."
kubectl delete -f kubernetes/database/ -n "$NAMESPACE" --ignore-not-found=true

# Esperar a que los pods terminen
echo "⏳ Esperando a que los pods terminen..."
kubectl wait --for=delete pods --all -n "$NAMESPACE" --timeout=60s || true

# Verificar que todo se eliminó
echo "🔍 Verificando limpieza..."
remaining_pods=$(kubectl get pods -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l || echo "0")

if [ "$remaining_pods" -eq 0 ]; then
    echo "✅ Todos los recursos eliminados exitosamente"
else
    echo "⚠️  Algunos recursos pueden estar aún terminando:"
    kubectl get pods -n "$NAMESPACE" || true
fi

# Opción para eliminar el namespace completo
if [ "$FORCE" = "true" ]; then
    echo "🗑️ Eliminando namespace completo..."
    kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
fi

echo "🎉 Limpieza completada!"