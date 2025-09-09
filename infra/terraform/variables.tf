variable "region" {
    type = string
    default = "us-east-1"
}

variable "use_localstack" {
    type = bool
    default = true
}

variable "localstack_endpoint" {
    type = string
    default = "http://localstack:4566"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "lambda_function_name" {
    type = string
    default = ""
}