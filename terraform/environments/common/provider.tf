terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.68"
    }
  }
}

provider "snowflake" {
  alias    = "terraform"
  account  = var.account
  username = var.username
  password = var.password
  region  = var.region
  role  = var.role
  warehouse  = var.warehouse
}