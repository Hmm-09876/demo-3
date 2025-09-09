set -euo pipefail

echo "Running pytest..."
pip install -r src/demo_app/requirements.txt
python -m pytest tests/unit/test_app.py || { echo "Tests failed"; exit 1; }

TAG=${1:-"test-local"}
bash scripts/build.sh "${TAG}"

CONTAINER_NAME="demo_app_test_${RANDOM}"
docker run -d --name ${CONTAINER_NAME} -p 8080:8080 demo_app:${TAG}
sleep 2

if curl -fsS http://localhost:8080/health >/dev/null; then
    echo "Health check passed"
    docker rm -f ${CONTAINER_NAME}
    exit 0
else
    echo "Health check failed"
    docker logs ${CONTAINER_NAME} || true
    docker rm -f ${CONTAINER_NAME}
    exit 2
fi