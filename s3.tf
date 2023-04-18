resource "aws_s3_bucket" "this" {
  bucket        = var.s3_bucket_name
  force_destroy = var.s3_bucket_force_destroy
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.s3_enable_versioning ? 1 : 0

  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "CloudFrontReadGetObject",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.this.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.this.arn
          }
        }
      },
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "dummy" {
  count = var.s3_add_dummy_page ? 1 : 0

  bucket       = aws_s3_bucket.this.id
  key          = "index.html"
  content_type = "text/html"
  content      = "<h1>hello</h1>"
}

resource "aws_s3_object" "error" {
  count = var.s3_add_error_page ? 1 : 0

  bucket       = aws_s3_bucket.this.id
  key          = "error.html"
  content_type = "text/html"
  content      = "<h1>Not Found</h1>"
}
