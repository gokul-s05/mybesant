#!/bin/bash
set -e  # Exit immediately on any error

# ─────────────────────────────────────────────
# CONFIGURATION — change these before running
# ─────────────────────────────────────────────
DOCKERHUB_USERNAME="your_dockerhub_username"   # ← replace this
IMAGE_NAME="mybesant-webserver"
IMAGE_TAG="latest"
CONTAINER_NAME="mybesant-container"
HOST_PORT=8080
FULL_IMAGE="${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"

# ─────────────────────────────────────────────
# STEP 1: Build the Docker image
# ─────────────────────────────────────────────
echo ""
echo "🔨 [1/3] Building Docker image: ${FULL_IMAGE}"
docker build -t "${FULL_IMAGE}" .

echo "✅ Build successful."

# ─────────────────────────────────────────────
# STEP 2: Push image to DockerHub
# ─────────────────────────────────────────────
echo ""
echo "📤 [2/3] Pushing image to DockerHub..."
echo "   (Make sure you're logged in: run 'docker login' first)"
docker push "${FULL_IMAGE}"

echo "✅ Push successful."

# ─────────────────────────────────────────────
# STEP 3: Run container using the DockerHub image
# ─────────────────────────────────────────────
echo ""
echo "🚀 [3/3] Running container from DockerHub image..."

# Stop and remove existing container if it already exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "   Removing existing container: ${CONTAINER_NAME}"
  docker rm -f "${CONTAINER_NAME}"
fi

docker run -d \
  --name "${CONTAINER_NAME}" \
  -p "${HOST_PORT}:80" \
  "${FULL_IMAGE}"

echo ""
echo "✅ Container is running!"
echo "   🌐 Open your browser at: http://localhost:${HOST_PORT}"
echo "   📦 Image used: ${FULL_IMAGE}"
echo "   🔍 Check status: docker ps"
echo "   📋 View logs:    docker logs ${CONTAINER_NAME}"
echo "   🛑 Stop:         docker rm -f ${CONTAINER_NAME}"
