output "s3_bucket_name" {
  value       = module.s3_bucket.bucket_id  
}

output "lambda_function_name" {
  value       = module.lambda_function.function_name
}