# terraform-aws-dotnet-lambda

_Terraform module to create a dotnet lambda function locally_

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.31.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [external_external.create_bundle](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_code_location"></a> [code\_location](#input\_code\_location) | The location of the dotnet code for the lambda function | `string` | `"src/"` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create a role for the Lambda function. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what your Lambda Function does | `string` | `""` | no |
| <a name="input_dotnet_runtime"></a> [dotnet\_runtime](#input\_dotnet\_runtime) | Dotnet runtime version for lambda to use | `string` | `"dotnet6"` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The name of the function. | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda Function entrypoint in your code | `string` | `""` | no |
| <a name="input_log_retention"></a> [log\_retention](#input\_log\_retention) | The number of days you want to retain log events in the specified log group. | `number` | `30` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | The amount of memory, in MB, your Lambda Function can use at runtime. Defaults to 128 MB. The value must be a multiple of 64 MB. | `number` | `128` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the IAM role that Lambda assumes when it executes your function to access any other Amazon Web Services (AWS) resources. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->