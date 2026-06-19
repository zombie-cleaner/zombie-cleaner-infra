output "lambda_arns_for_eventbridge" {
  value = {
    for lambda in local.lambda_functions :
    lambda.name => aws_lambda_function.lambdaFunctions["${lambda.name}"].arn
    if lambda.allow_eventbridge
  }
}

output "all_lambda_names" {
  value = [for val in local.lambda_functions : val.name if val.enable_cloudwatch_logs == true]
}
