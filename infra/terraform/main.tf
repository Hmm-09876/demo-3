locals {
  common_tags = {
    Project = "demo-3"
    env    = var.environment
  }
}

module "s3_bucket" {
  source = "./modules/s3"
  bucket_name = "${local.common_tags.Project}-${var.environment}-assets"
  tags = local.common_tags
}

module "lambda_function" {
    source = "./modules/lambda"
    function_name = var.lambda_function_name != "" ? var.lambda_function_name : "${local.common_tags.Project}-${var.environment}-function"
    s3_bucket = module.s3_bucket.bucket_id
    s3_key = "function.zip"
    tags = local.common_tags
}