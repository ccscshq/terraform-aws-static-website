resource "aws_ssm_parameter" "this" {
  name  = "/${var.prefix}/${var.s3_bucket_name}/basic_auth/password"
  type  = "SecureString"
  value = random_password.this.result
}
