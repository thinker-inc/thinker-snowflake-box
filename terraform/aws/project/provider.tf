terraform {
  required_version = "~> 1.7.0"

  backend "s3" {
    bucket         = "terraform-state-snowflake-aws"
    region         = "ap-northeast-1"
    encrypt        = "true"
    key            = "terraform/resource/common-aws.tfstate"
    dynamodb_table = "common-aws-terraform-state-lock"
    profile        = "thinker-snowflake-terraform"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.44.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      env     = var.environment
      project = "common-aws-terraform"
      owner   = "terraform"
      tfstate = "common-aws"
    }
  }
  profile = "thinker-snowflake-terraform"
}
