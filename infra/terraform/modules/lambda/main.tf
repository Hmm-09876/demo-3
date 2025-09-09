locals {
    use_s3 = length(trim(var.s3_bucket, "")) > 0
}

data "archive_file" "lambda_zip" {
  type = "zip"
  source_dir = "${path.root}/../../src/lambda_func"
  output_path = "${path.module}/function.zip"
}

resource "aws_s3_bucket_object" "lambda_zip" {
  count = var.use_s3 ? 1 : 0
  bucket = var.s3_bucket
  key = var.s3_key != "" ? var.s3_key : "${var.function_name}.zip"
  source = data.archive_file.lambda_zip.output_path
  etag = filemd5(data.archive_file.lambda_zip.output_path)
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role = aws_iam_role.lambda_exec.arn
  handler = var.handler
  runtime = var.runtime

  filename = var.use_s3 ? null : data.archive_file.lambda_zip.output_path
  s3_bucket = var.use_s3 ? aws_s3_bucket_object.lambda_zip[0].bucket : null
  s3_key = var.use_s3 ? aws_s3_bucket_object.lambda_zip[0].key : null
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  tags = var.tags
}

