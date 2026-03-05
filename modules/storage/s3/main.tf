resource "aws_s3_bucket" "platform_access_policy_bucket" {
  bucket = "${var.platformAccessPolicyBucket.bucket}-${var.globalConfigs.environment}-${var.globalConfigs.appName}"
}
resource "aws_s3_bucket_public_access_block" "allowPublicTraffic" {
  bucket = aws_s3_bucket.platform_access_policy_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}
resource "aws_s3_bucket_policy" "s3_public_read" {
  bucket = aws_s3_bucket.platform_access_policy_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.platform_access_policy_bucket.arn}/*"
    }]
  })
}
resource "aws_s3_object" "platformAccessPolicyObject" {
  source       = "${var.globalConfigs.policiesLocation}${var.platformAccessPolicyBucket.policyFile}"
  bucket       = aws_s3_bucket.platform_access_policy_bucket.id
  key          = "platformAccessPolicy.json"
  content_type = "text/json"

  # Adding a hash of the file content to force updates when the file changes
  etag = filemd5("${var.globalConfigs.policiesLocation}${var.platformAccessPolicyBucket.policyFile}")
}

