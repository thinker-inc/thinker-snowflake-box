terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.98.0"
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
  alias = "fr_security_manager"
  role  = "FR_SECURITY_MANAGER"
}
