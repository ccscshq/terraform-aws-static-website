data "aws_route53_zone" "this" {
  name = "${var.hosted_zone_domain}."
}
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}
