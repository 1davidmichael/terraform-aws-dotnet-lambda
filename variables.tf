variable "function_name" {
  type        = string
  description = "The name of the function."
}

variable "role_arn" {
  type        = string
  description = "The ARN of the IAM role that Lambda assumes when it executes your function to access any other Amazon Web Services (AWS) resources."
  default     = ""
}

variable "create_role" {
  type        = bool
  description = "Whether to create a role for the Lambda function."
  default     = false
}

variable "log_retention" {
  type        = number
  description = "The number of days you want to retain log events in the specified log group."
  default     = 30
}

variable "dotnet_runtime" {
  type        = string
  description = "Dotnet runtime version for lambda to use"
  default     = "dotnet6"
  validation {
    condition     = can(contains(["dotnetcore3.1", "dotnet5.0", "dotnet6"], var.dotnet_runtime))
    error_message = "The runtime value must be one of supported by AWS Lambda."
  }
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = ""
  validation {
    condition     = can(var.handler != "")
    error_message = "The handler value must be set."
  }
}

variable "description" {
  type        = string
  description = "Description of what your Lambda Function does"
  default     = ""
}

variable "memory_size" {
  type        = number
  description = "The amount of memory, in MB, your Lambda Function can use at runtime. Defaults to 128 MB. The value must be a multiple of 64 MB."
  default     = 128
  validation {
    condition     = can(var.memory_size % 64 == 0) && can(var.memory_size >= 128) && can(var.memory_size <= 10240)
    error_message = "The memory_size value must be greater than 128 and less than 10240"
  }
}

variable "code_location" {
  type        = string
  description = "The location of the dotnet code for the lambda function"
  default     = "src/"
  validation {
    condition     = can(var.code_location != "")
    error_message = "The handler value must be set."
  }
}
