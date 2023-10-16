resource "aws_cloudfront_distribution" "this" {

  aliases = [var.website_domain]

  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.this.id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  web_acl_id          = var.enable_ip_address_blocking ? aws_wafv2_web_acl.this.arn : null
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.this.id
    compress         = true

    cache_policy_id = data.aws_cloudfront_cache_policy.this.id

    viewer_protocol_policy = "redirect-to-https"

    dynamic "function_association" {
      for_each = var.enable_basic_auth ? [""] : []
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.this.arn
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.virginia.arn
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 404
    response_page_path = "/error.html"
  }
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.prefix}-cloudfront-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "this" {
  name    = "${var.prefix}-basic-auth"
  runtime = "cloudfront-js-1.0"
  comment = "This function provides basic authentication."
  publish = true
  code = templatefile("${path.module}/templates/cf_functions/basic_auth.js", {
    user : var.basic_auth_username == null ? var.prefix : var.basic_auth_username,
    pass : aws_ssm_parameter.this.value
  })
}
