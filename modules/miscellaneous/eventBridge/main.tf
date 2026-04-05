locals {
  events = [
    {
      "name" : "event1",
      "description" : "This is the first event",
      "lambda_arn" : var.lambda_arns_for_eventbridge["delete_resource"],
      "event_pattern" : {
        "detail" : {
          type = ["DELETE_RESOURCE"]
        }
      }
    }
  ]
}

resource "aws_cloudwatch_event_rule" "allRules" {
  for_each = { for event in local.events : event.name => event }

  name          = "${each.value.name}-${var.globalConfigs.environment}-${var.globalConfigs.appName}"
  description   = each.value.description
  event_pattern = jsonencode(each.value.event_pattern)

}

resource "aws_cloudwatch_event_target" "mapTargets" {
  for_each = { for event in local.events : event.name => event }

  rule      = "${aws_cloudwatch_event_rule.allRules[each.key].name}-${var.globalConfigs.environment}-${var.globalConfigs.appName}"
  target_id = "${each.key}-target"
  arn       = each.value.lambda_arn
}
