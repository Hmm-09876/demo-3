[![CI](https://github.com/Hmm-09876/demo-3/actions/workflows/ci.yml/badge.svg)](https://github.com/Hmm-09876/demo-3/actions)
# Mục tiêu demo-3

1. Terraform (local) tạo S3 bucket + Lambda.

2. LocalStack (docker-compose) mô phỏng AWS cho test cục bộ.

3. Tests pytest + boto3 để kiểm tra upload S3 và Lambda.

4. Makefile + CI (GitHub Actions) để tự động hoá.

***
# Những gì cần cài ban đầu

Docker Engine: 
https://docs.docker.com/engine/install/ubuntu/

Terraform: 
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Python, pip, Make: 
```
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.10 python3-pip make
```

# Quick start

1. Cài đặt dependencies Python
```
cd demo-3-master
python -m pip install --upgrade pip
pip install -r requirements.txt
```

2. Khởi động LocalStack
```
cd localstack
docker compose up -d
cd ..
```

3. Áp dụng Terraform (local)
```
cd terraform-local
tflocal init
tflocal apply -auto-approve
cd ..
```

4. Thiết lập thông báo S3 -> Lambda
```
make s3-notify
```

5. Thử invoke Lambda thủ công 
```
make lambda-invoke PAYLOAD='{"key": "value"}'
make lambda-logs
```

## Thu thập bằng chứng (evidence)
```
make evidence
```