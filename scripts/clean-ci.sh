set -euo pipefail

LS_DIR="infra/localstack"
DRY_RUN=${DRY_RUN:-false}

run (){
    if [ "DRY_RUN" = "true" ]; then
        echo "[DRY RUN] $*"
    else
        echo "[RUN] $*"
        eval "$@"
    fi
}

for f in "$LS_DIR"/docker-compose.yml; do
    [ -f "$f" ] || continue
    run "docker compose -f "$f" down -v"
done

run "docker system prune --all --volumes -f || true"

echo "Cleanup complete."