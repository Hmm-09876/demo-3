provider "aws" {
    region = "us-west-1"    
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "demo-terraform-bucket"
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.demo_bucket.id
  acl    = "private"
}

resource "aws_iam_role" "lambda_exec" {
    name = "lambda_exec_role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "lambda.amazonaws.com"
            }
            Sid = ""
        }
        ]
    })  
}

resource "aws_lambda_function" "demo" {
    function_name = "demo_lambda"
    filename = "function.zip"
    handler = "handler.handler"
    runtime = "python3.10"
    role = aws_iam_role.lambda_exec.arn
}