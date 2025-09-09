variable "function_name" {
  type        = string
}

variable "use_s3" {
  type        = bool
  default     = false
}

variable "s3_bucket" {
  type = string
  default = ""
}

variable "s3_key" {
  type = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "handler" {
  type = string
  default = "handler.handler"
}

variable "runtime" {
  type = string
  default = "python3.11"
}