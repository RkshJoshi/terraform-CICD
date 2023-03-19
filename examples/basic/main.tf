terraform {
  required_version = ">= 1"
  required_providers {}
}

provider "aws" {
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "Basic Example"
    }
  }
}

module "example" {
  source = "../.."
}
