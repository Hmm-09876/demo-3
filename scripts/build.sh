set -euo pipefail

IMAGE_TAG=${1:-"local"}
REPO=${REPO:-"demo_app"}
IMAGE_NAME="${REPO}:${IMAGE_TAG}"

echo "Building Docker image: ${IMAGE_NAME}"
docker build -t ${IMAGE_NAME} src/demo_app

echo "Docker image ${IMAGE_NAME} built successfully."
docker images --filter=reference="${IMAGE_NAME}" 