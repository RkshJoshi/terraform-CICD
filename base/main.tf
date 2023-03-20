terraform {
  required_version = ">-1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      versions = ">=4.29.0, <5"
    }
  }
}

provider "aws" {
  # profile = "rakesh-personal"
  # region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = var.short_id
      Projects = var.name
    }
  }
}