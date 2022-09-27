output "lambda_function_arn" {
  value = try(aws_lambda_function.this[0].arn, "")
}

output "lambda_function_role_arn" {
  value = var.create_role ? aws_iam_role.this[0].arn : var.role_arn
}
