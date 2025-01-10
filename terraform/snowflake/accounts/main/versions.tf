terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 1.0.1"
    }
  }
}

# 事前にSYSADMINとSECURITYADMINをGRANTしたロール。
provider "snowflake" {
  alias = "terraform"
  role  = "TERRAFORM_SR"
  preview_features_enabled = [
    "snowflake_file_format_resource",
    "snowflake_storage_integration_resource",
    "snowflake_stage_resource",
  ]
}

provider "snowflake" {
  alias = "sys_admin"
  role  = "SYSADMIN"
  preview_features_enabled = [

  ]
}

provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
  preview_features_enabled = [

  ]
}

provider "snowflake" {
  alias = "fr_security_manager"
  role  = "FR_SECURITY_MANAGER"
  preview_features_enabled = [
    "snowflake_network_rule_resource",
    "snowflake_network_policy_attachment_resource",
    "snowflake_password_policy_resource",
    "snowflake_account_password_policy_attachment_resource",
    "snowflake_authentication_policy_resource",
    "snowflake_account_authentication_policy_attachment_resource",
    "snowflake_user_authentication_policy_attachment_resource",
  ]
}
