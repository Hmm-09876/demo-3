[![CI](https://github.com/Hmm-09876/demo-3/actions/workflows/ci.yml/badge.svg)](https://github.com/Hmm-09876/demo-3/actions)
# Mục tiêu đã đạt trong demo-3

1. Viết module Terraform cho Lambda & S3.

2. LocalStack (docker-compose) mô phỏng AWS cho test cục bộ.

3. Tests pytest + boto3 để kiểm tra upload S3 và Lambda.

4. Makefile + CI (GitHub Actions) để tự động hoá.

5. Build & push Docker image lên GHCR.

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
docker pull ghcr.io/hmm-09876/demo-3/demo-app:ci-89bc489ff38ed8d270bdcedc17a88bc9e774a1d6
```

