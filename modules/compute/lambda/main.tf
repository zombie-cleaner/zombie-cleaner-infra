locals {
  lambda_functions = [
    {
      name        = "delete_resource",
      description = "Lambda function to handle resource deletion events",
      handler     = "index.handler",
      runtime     = "nodejs18.x",
      code_path   = "${path.module}/functions/delete_resource"
      layers      = ["api-helper", "package"]
      environment_variables = {
        "REGION" : "${var.globalConfigs.region}"
      }
      allow_eventbridge      = true
      enable_cloudwatch_logs = true
    },
    # {
    #   name              = "schedule_resource",
    #   description       = "Lambda function to handle resource updation events",
    #   handler           = "index.handler",
    #   runtime           = "nodejs18.x",
    #   code_path         = "${path.module}/functions/update_resource"
    #   allow_eventbridge = true
    #   enable_cloudwatch_logs = true
    #   layers            = ["api-helper", "package"]
    #   environment_variables = {
    #     "REGION" : "${var.globalConfigs.region}"
    #   }
    # }
  ]
  lambda_layers = [
    {
      name      = "api-helper"
      code_path = "${path.module}/layers/api-helper"
    },
    {
      name      = "package"
      code_path = "${path.module}/layers/package"
    }
  ]
}

data "archive_file" "lambda_zips" {
  for_each = { for lambda in local.lambda_functions : lambda.name => lambda }

  type        = "zip"
  source_dir  = "${path.module}/functions/${each.value.name}"
  output_path = "${path.module}/functions/${each.value.name}.zip"
  excludes    = ["**/*.zip"]
}
data "archive_file" "lambda_layer_zips" {
  for_each = { for layer in local.lambda_layers : layer.name => layer }

  type        = "zip"
  source_dir  = "${path.module}/layers/${each.value.name}"
  output_path = "${path.module}/layers/${each.value.name}.zip"
  excludes    = ["**/*.zip"]
}

resource "aws_lambda_layer_version" "lambdaLayers" {
  for_each = { for layer in local.lambda_layers : layer.name => layer }

  filename            = "${path.module}/layers/${each.value.name}.zip"
  layer_name          = "${each.value.name}-${var.globalConfigs.environment}-${var.globalConfigs.appName}"
  source_code_hash    = data.archive_file.lambda_layer_zips[each.key].output_base64sha256
  compatible_runtimes = ["nodejs18.x"]
}

resource "aws_lambda_function" "lambdaFunctions" {
  for_each = { for lambda in local.lambda_functions : lambda.name => lambda }

  function_name    = "${each.value.name}-${var.globalConfigs.environment}-${var.globalConfigs.appName}"
  description      = each.value.description
  handler          = each.value.handler
  runtime          = each.value.runtime
  filename         = "${path.module}/functions/${each.value.name}.zip"
  source_code_hash = data.archive_file.lambda_zips[each.key].output_base64sha256
  role             = aws_iam_role.lambda_execution_role.arn
  layers           = [for layer in each.value.layers : aws_lambda_layer_version.lambdaLayers[layer].arn]

  environment {
    variables = each.value.environment_variables
  }
}

resource "aws_lambda_permission" "allow_eventbridge" {
  for_each      = { for lambda in local.lambda_functions : lambda.name => lambda if lambda.allow_eventbridge }
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

resource "aws_iam_role_policy" "allow_assume_idlezero_role" {
  name = "allow-assume-idlezero-role"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::*:role/IdleZeroAccessRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
