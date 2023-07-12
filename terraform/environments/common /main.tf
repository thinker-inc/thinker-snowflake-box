# module "snowflake_role" {
# # ここで読み込みたい source
#   source = "./modules/snowflake/preset_user/"
#   providers = {
#     snowflake = snowflake.accountadmin
#   }

#   # 上で読み込んだ階層にいる variables.tf に渡すための変数
# #   users  = toset(var.users)

#   # 上で読み込んだリソースで使用するsnowflake provider
#   # ACCOUNTADMIN用のproviderを指定

# }


terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.61"
    }
  }
}

provider "snowflake" {
  role  = "SYSADMIN"
}

resource "snowflake_database" "db" {
  name     = "TF_DEMO"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "TF_DEMO"
  warehouse_size = "large"

  auto_suspend = 60
}