[![CI](https://github.com/Hmm-09876/demo-3/actions/workflows/ci.yml/badge.svg)](https://github.com/Hmm-09876/demo-3/actions)
# Mục tiêu demo-3

1. Terraform (local) tạo S3 bucket + Lambda.

2. LocalStack (docker-compose) mô phỏng AWS cho test cục bộ.

3. Tests pytest + boto3 để kiểm tra upload S3 và Lambda.

4. Makefile + CI (GitHub Actions) để tự động hoá.

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

