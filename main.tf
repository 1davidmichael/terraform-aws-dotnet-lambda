terraform {
  required_version = ">= 1.2.0"
}

locals {
  output_dir = abspath("${path.root}/build")
}

# Outputs the following:
# location = output bundle file
# hash = mmd5sum of the bundle file
data "external" "build_folder" {
  program = ["bash", "${path.module}/bin/folder_contents.sh"]
  query = {
    output_dir    = local.output_dir
    code_location = var.code_location
  }
}

# Build lambda when contents of the directory have changed
resource "null_resource" "create_package" {
  triggers = {
    output_file_location = data.external.build_folder.result.location
  }

  provisioner "local-exec" {
    command = "${path.module}/bin/package.sh ${data.external.build_folder.result.location} ${var.code_location} ${var.architecture}"
  }
}

resource "aws_lambda_function" "this" {
  count = var.create_function ? 1 : 0
  depends_on = [
    null_resource.create_package
  ]
  function_name = var.function_name
  role          = var.create_role ? aws_iam_role.this[0].arn : var.role_arn
  runtime       = var.dotnet_runtime
  handler       = var.handler
  description   = var.description
  memory_size   = var.memory_size
  filename      = data.external.build_folder.result.location
  architectures = [var.architecture]
  tracing_config {
    mode = var.tracing_mode
  }
}

resource "aws_kms_key" "key" {
  count               = var.create_key ? 1 : 0
  description         = "KMS key for ${var.function_name}"
  enable_key_rotation = true
}

resource "aws_cloudwatch_log_group" "example" {
  count             = var.create_function ? 1 : 0
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention
  kms_key_id        = var.create_key ? aws_kms_key.key[0].arn : null
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
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
