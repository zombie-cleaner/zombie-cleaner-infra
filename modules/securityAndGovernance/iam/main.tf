# data "aws_iam_policy_document" "s3_read" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["arn:aws:s3:::${var.platformAccessPolicyBucket}/*"]
#   }
# }

# resource "aws_iam_policy" "s3_read" {
#   name   = "s3-read-policy-${var.platformAccessPolicyBucket}-${var.globalConfigs.environment}-${var.globalConfigs.appName}"
#   policy = data.aws_iam_policy_document.s3_read.json
# }
