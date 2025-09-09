provider "aws" {
    region = var.region
    skip_credentials_validation = var.use_localstack ? true : false
    skip_requesting_account_id = var.use_localstack ? true : false
    s3_use_path_style = var.use_localstack ? true : false
    access_key = var.use_localstack ? "test" : null
    secret_key = var.use_localstack ? "test" : null

    endpoints {
        s3 = var.use_localstack ? var.localstack_endpoint : null
        lambda = var.use_localstack ? var.localstack_endpoint : null
        iam = var.use_localstack ? var.localstack_endpoint : null
        sts = var.use_localstack ? var.localstack_endpoint : null
    }
}


