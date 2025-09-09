set -euo pipefail

IMAGE=${1:?Usage: ./scripts/deploy.sh <image> [kubecontext]}
KUBECTX=${2:-""}
DEPLOYMENT_NAME=${DEPLOYMENT_NAME:-"demo-app"}
CONTAINER_NAME=${CONTAINER_NAME:-"demo-app"}
NAMESPACE=${NAMESPACE:-"default"}

CTX_ARG=()
if [[ -n "${KUBECTX}" ]]; then
    CTX_ARG=(--context "${KUBECTX}")
    echo "Using kube context: ${KUBECTX}"
fi

echo "Updating deployment ${DEPLOYMENT_NAME} in namespace ${NAMESPACE} to image ${IMAGE}"
kubectl "${CTX_ARG[@]}" -n "${NAMESPACE}" set image "deployment/${DEPLOYMENT_NAME}" "${CONTAINER_NAME}=${IMAGE}" --record
kubectl "${CTX_ARG[@]}" -n "${NAMESPACE}" rollout status "deployment/${DEPLOYMENT_NAME}"
echo "Deployment updated successfully."