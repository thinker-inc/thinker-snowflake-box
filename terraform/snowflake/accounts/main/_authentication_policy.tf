# ########################
# # Authentication Policy
# https://docs.snowflake.com/en/user-guide/authentication-policies#label-authentication-policy-hardening-authentication
# https://docs.snowflake.com/ja/sql-reference/functions/policy_references
# ########################
# アカウント全体（UIアクセス用 - MFA必須）
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

# 開発者用ポリシー（API/ドライバーアクセス用 - キーペア認証）
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
  users                      = local.manager
}

# TROCCO用ポリシー
module "trocco_authentication_policy" {
  depends_on = [module.security_db_authentication_schema]
  source     = "../../modules/authentication_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  database = module.security_db.name
  schema   = module.security_db_authentication_schema.name
  name     = "TROCCO_AUTHENTICATION_USER_POLICY"

  authentication_methods = ["KEYPAIR"]
  client_types           = ["DRIVERS"]
  users = [
    "TROCCO_USER"
  ]
}

# Tableau用ポリシー（OAuth認証）
module "tableau_authentication_policy" {
  depends_on = [module.security_db_authentication_schema, module.tableau_cloud_oauth_integration, module.tableau_desktop_oauth_integration]
  source     = "../../modules/authentication_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  database = module.security_db.name
  schema   = module.security_db_authentication_schema.name
  name     = "TABLEAU_OAUTH_AUTHENTICATION_POLICY"

  authentication_methods = ["OAUTH"]
  client_types           = ["DRIVERS"]
  mfa_enrollment         = "OPTIONAL"
  users                  = [] # TableauはOAuthでログインするので、Snowflake側で個別のユーザーを指定する必要がない
}
