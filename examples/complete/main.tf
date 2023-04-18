module "website" {
  source = "../../"

  providers = {
    aws.virginia = aws.virginia
  }

  prefix                     = local.prefix
  hosted_zone_domain         = "example.com"
  website_domain             = "web.example.com"
  s3_bucket_name             = "web.example.com"
  s3_bucket_force_destroy    = true
  s3_enable_versioning       = true
  s3_add_dummy_page          = true
  s3_add_error_page          = true
  enable_ip_address_blocking = true
  allowed_ip_addresses = [
    "111.22.111.22/32",
  ]
  enable_basic_auth   = true
  basic_auth_username = "username"
}
