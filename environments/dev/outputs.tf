# logging 
output "lambda_names" {
  value = toset(module.lambda.all_lambda_names)
}
