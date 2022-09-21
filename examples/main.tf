resource "random_pet" "this" {
  length = 2
}

provider "external" {}

provider "aws" {
  region = "us-east-1"
}

module "dotnet_lambda" {
  source         = "../"
  function_name  = "dotnet-lambda-${random_pet.this.id}"
  handler        = "examples::examples.Function::FunctionHandler"
  dotnet_runtime = "dotnet6"
  code_location  = "src/examples/"
}

output "lambda_function_arn" {
  value = module.dotnet_lambda.lambda_function_arn
}
