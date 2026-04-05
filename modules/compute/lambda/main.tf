locals {
  lambda_functions = [
    {
      name              = "delete_resource",
      description       = "Lambda function to handle resource deletion events",
      handler           = "index.handler",
      runtime           = "nodejs18.x",
      code_path         = "${path.module}/functions/delete_resource"
      allow_eventbridge = true
      layers            = []
    }
  ]
}

resource "aws_lambda_function" "lambdaFunctions" {
  for_each = { for lambda in local.lambda_functions : lambda.name => lambda }

  function_name    = "${each.value.name}-${var.globalConfigs.environment}-${var.globalConfigs.appName}"
  description      = each.value.description
  handler          = each.value.handler
  runtime          = each.value.runtime
  filename         = "${each.value.code_path}/index.mjs"
  source_code_hash = filebase64sha256("${each.value.code_path}/index.mjs")
  role             = aws_iam_role.lambda_execution_role.arn
  layers           = each.value.layers
}

resource "aws_lambda_permission" "allow_eventbridge" {
  for_each = { for lambda in local.lambda_functions : lambda.name => lambda if lambda.allow_eventbridge }

  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = "${each.value.name}-${var.globalConfigs.environment}-${var.globalConfigs.appName}"
  principal     = "events.amazonaws.com"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role-${var.globalConfigs.environment}-${var.globalConfigs.appName}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
