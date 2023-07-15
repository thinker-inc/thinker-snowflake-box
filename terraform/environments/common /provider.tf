terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.68"
    }
  }
}

provider "snowflake" {
  alias    = "tf_useradmin"
  account  = var.account_useradmin
  username = var.username_useradmin
  password = var.password_useradmin
  region  = var.region_useradmin
  role  = var.role_useradmin
}

provider  "snowflake" {
  alias    = "tf_securityadmin"
  account  = var.account_securtyadmin
  username = var.username_securtyadmin
  password = var.password_securtyadmin
  region  = var.region_securtyadmin
  role  = var.role_securtyadmin
}

# provider "snowflake_sysadmin" {
#   alias    = "tf_snowflake_sysadmin"
#   account  = var.account_sysadmin
#   username = var.username_sysadmin
#   password = var.password_sysadmin
#   region  = var.region_sysadmin
#   role  = var.role_sysadmin
#   warehouse = var.warehouse_sysadmin
# }