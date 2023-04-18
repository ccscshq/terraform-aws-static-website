variable "prefix" {
  description = "Name prefix for resources."
  type        = string
}
variable "hosted_zone_domain" {
  description = "Domain name to use for the Route53 hosted zone."
  type        = string
}
variable "website_domain" {
  description = "Domain name to use for the website."
  type        = string
}
variable "s3_bucket_name" {
  description = "S3 bucket name of the static website."
  type        = string
}
variable "s3_bucket_force_destroy" {
  description = "Whether to forcibly delete the S3 bucket."
  type        = bool
  default     = false
}
variable "s3_enable_versioning" {
  description = "Whether versioning is enabled or not."
  type        = bool
  default     = false
}
variable "s3_add_dummy_page" {
  description = "Whether to create the simple index.html."
  type        = bool
  default     = false
}
variable "s3_add_error_page" {
  description = "Whether to create the default 404 error page."
  type        = bool
  default     = false
}
variable "enable_ip_address_blocking" {
  description = "Whether IP address blocking is enabled or not."
  type        = bool
}
variable "allowed_ip_addresses" {
  description = "Whether to create the default 404 error page."
  type        = set(string)
  default     = []
}
variable "enable_basic_auth" {
  description = "Whether basic authentication is enabled or not."
  type        = bool
}
variable "basic_auth_username" {
  description = "Username of the basic authentication."
  type        = string
  default     = null
}
