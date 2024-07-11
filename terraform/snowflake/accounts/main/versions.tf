terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.93.0"
    }
  }
}

# 事前にSYSADMINとSECURITYADMINをGRANTしたロール。
provider "snowflake" {
  alias = "terraform"
  role  = "TERRAFORM"
}

provider "snowflake" {
  alias = "sys_admin"
  role  = "SYSADMIN"
}

provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
}
