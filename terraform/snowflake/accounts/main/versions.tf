terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.95.0"
    }
  }
}

# 事前にSYSADMINとSECURITYADMINをGRANTしたロール。
provider "snowflake" {
  alias = "terraform"
  role  = "TERRAFORM_SR"
}

provider "snowflake" {
  alias = "sys_admin"
  role  = "SYSADMIN"
}

provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
}

provider "snowflake" {
  alias = "fr_manager"
  role  = "FR_MANAGER"
}
