output "lambda_arns_for_eventbridge" {
  value = {
    for lambda in local.lambda_functions :
    lambda.name => aws_lambda_function.lambdaFunctions["${lambda.name}"].arn
    if lambda.allow_eventbridge
  }
}
