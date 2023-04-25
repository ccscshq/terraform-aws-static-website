provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"

  default_tags {
    tags = local.default_tags
  }
}
