
terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # Version 5.x introduces some breaking changes for aws_elasticache_* resources
      # and this module does not support it
      version = "< 5.0.0"
    }
  }
}
