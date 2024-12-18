# ########################
# # Authentication Policy
# ########################
# Snowflake Account全体
module "account_authentication_policy" {
  depends_on = [module.developer_authentication_policy]
  source     = "../../modules/authentication_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  is_account = true
  database   = module.security_db.name
  schema     = module.security_db_authentication_schema.name
  name       = "REQUIRE_MFA_AUTHENTICATION_ACCOUNT_POLICY"

  authentication_methods     = ["PASSWORD"]
  client_types               = ["SNOWFLAKE_UI"]
  mfa_authentication_methods = ["PASSWORD"]
  mfa_enrollment             = "REQUIRED"
}

# 開発者用ポリシー
module "developer_authentication_policy" {
  depends_on = [module.security_db_authentication_schema]
  source     = "../../modules/authentication_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  database = module.security_db.name
  schema   = module.security_db_authentication_schema.name
  name     = "DEVELOPER_AUTHENTICATION_USER_POLICY"

  authentication_methods     = ["ALL"]
  client_types               = ["ALL"]
  mfa_authentication_methods = ["PASSWORD"]
  mfa_enrollment             = "REQUIRED"
  users = [
    "RYOTA_HASEGAWA",
    "HUNAG"
  ]
}

# トロッコ用ポリシー
module "trocco_authentication_policy" {
  depends_on = [module.security_db_authentication_schema]
  source     = "../../modules/authentication_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  database = module.security_db.name
  schema   = module.security_db_authentication_schema.name
  name     = "trocco_authentication_user_policy"

  authentication_methods = ["KEYPAIR"]
  client_types           = ["DRIVERS"]
  users = [
    "TROCCO_USER"
  ]
}
