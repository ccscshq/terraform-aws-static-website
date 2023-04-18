output "s3_bucket_arn" {
  description = "The ARN of the s3 bucket."
  value       = aws_s3_bucket.this.arn
}
