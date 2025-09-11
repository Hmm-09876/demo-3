[![CI](https://github.com/Hmm-09876/demo-3/actions/workflows/ci.yml/badge.svg)](https://github.com/Hmm-09876/demo-3/actions/workflows/ci.yml)

[![CD](https://github.com/Hmm-09876/demo-3/actions/workflows/cd.yml/badge.svg)](https://github.com/Hmm-09876/demo-3/actions/workflows/cd.yml)

[![Security Scan](https://github.com/Hmm-09876/demo-3/actions/workflows/sec-scan.yml/badge.svg)](https://github.com/Hmm-09876/demo-3/actions/workflows/sec-scan.yml)
# Mục tiêu đã đạt trong demo-3

1. Viết module Terraform cho Lambda & S3.

2. LocalStack (docker-compose) mô phỏng AWS để test cục bộ.

3. Tests: pytest + boto3 để kiểm tra upload S3 và deploy Lambda (unit + integration).

4. CI: lint, pytest, terraform validate và build image.

5. Makefile, script để tự động hoá wrap lệnh và test nhanh.

6. Build & push Docker image lên GHCR.

7. Security scan: scan image (Trivy).

8. CD (self-hosted runner):  
   - Build image → push GHCR (nếu có `GHCR_TOKEN`).  
   - Restore kubeconfig từ secret (`KUBE_CONFIG`).  
   - Deploy vào namespace `ci-deploy` (hoặc `K8S_NAMESPACE`), dùng `kubectl set image` hoặc thay `IMAGE_PLACEHOLDER` trong `k8s/` và `kubectl apply`.  
   - Rollout check + diagnostic logs on fail.

9. Hiểu rõ hơn về cơ chế của git và github action (chủ yếu về các nhánh cũng như các loại trigger).

***
# Nguồn cài và tham khảo

Docker Engine: 
https://docs.docker.com/engine/install/ubuntu/

Terraform: 
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

kind:
https://kind.sigs.k8s.io/docs/user/quick-start/

kubectl:
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

Python, pip, Make: 
```
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.10 python3-pip make
```

***
# Pull & run image từ GHCR
```
docker pull ghcr.io/hmm-09876/demo-3/demo-app:ci-54fca15914be974f1fed0ae748c076fba4f39c4b
```

