terraform {
  required_version = "~> 1.2.0"
}

locals {
  output_zip_file = "$TMP"
}

resource "null_resource" "bundle" {
  provisioner "local-exec" {
    command     = "dotnet lambda package -c Release -o $TMP/${var.code_location}.zip"
    working_dir = var.code_location
  }
}

data "local_file" "lambda_zip" {
  filename = "value"
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.create_role ? aws_iam_role.this[0].arn : var.role_arn
  runtime       = var.dotnet_runtime
  handler       = var.handler
  description   = var.description
  memory_size   = var.memory_size
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention
}

resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  count      = var.create_role ? 1 : 0
  role       = aws_iam_role.this[0].arn
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
