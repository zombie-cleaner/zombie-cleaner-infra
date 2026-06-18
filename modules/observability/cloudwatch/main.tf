# import block for resource already there in aws
import {
  to = aws_cloudwatch_log_group.lambda_cloudwatch_logs["delete_resource"]
  id = "/aws/lambda/delete_resource-dev-zombie-cleaner"
}

# resource "aws_cloudwatch_log_group" "lambda_cloudwatch_logs" {
#   for_each          = toset(var.all_lambda_names)
#   name              = "/aws/lambda/${each.value}-${var.globalConfigs.environment}-${var.globalConfigs.appName}" # can be later configured by globalConfigs, vendor = aws, resource = lambda
#   retention_in_days = var.cloudwatchCommonConfigs.retention_in_days                                             # can be later configured by resource level retention policy 
# }
