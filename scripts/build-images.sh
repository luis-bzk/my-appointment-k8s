#!/bin/bash

set -e

REGISTRY="${REGISTRY:-luisberrezueta}"
TAG="${TAG:-latest}"
GITHUB_USER="${GITHUB_USER:-luis-bzk}"

echo "🏗️ Construyendo imágenes..."

# Construir imagen de base de datos
echo "📊 Construyendo citary-database..."
docker build -t ${REGISTRY}/citary-database:${TAG} \
  https://github.com/${GITHUB_USER}/citary-database.git

# Construir imagen de backend
echo "⚙️ Construyendo citary-backend..."
docker build -t ${REGISTRY}/citary-backend:${TAG} \
  https://github.com/${GITHUB_USER}/citary-backend.git

# Construir imagen de frontend
echo "🖥️ Construyendo citary-frontend..."
docker build -t ${REGISTRY}/citary-frontend:${TAG} \
  --build-arg VITE_API_URL=${VITE_API_URL:-http://localhost:3000} \
  https://github.com/${GITHUB_USER}/citary-frontend.git

echo "✅ Todas las imágenes construidas exitosamente"

# Push a registry si se especifica
if [ "$PUSH" = "true" ]; then
  echo "📤 Subiendo imágenes al registry..."
  docker push ${REGISTRY}/citary-database:${TAG}
  docker push ${REGISTRY}/citary-backend:${TAG}
  docker push ${REGISTRY}/citary-frontend:${TAG}
  echo "✅ Imágenes subidas exitosamente"
fi