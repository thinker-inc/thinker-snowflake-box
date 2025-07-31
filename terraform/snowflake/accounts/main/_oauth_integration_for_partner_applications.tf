# ########################
# # oauth integration for partner applications
# https://docs.snowflake.com/ja/sql-reference/sql/create-security-integration-oauth-snowflake
# https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/oauth_integration_for_partner_applications
# ########################

# Tableau Cloud用OAuth統合（パートナーアプリケーション）
module "tableau_cloud_oauth_integration" {
  source = "../../modules/oauth_integration_for_partner_applications"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  name                         = "TABLEAU_CLOUD_SECURITY_INTEGRATION"
  oauth_client                 = "TABLEAU_SERVER"
  comment                      = "for tableau cloud oauth (us-west-2)"
  enabled                      = true
  oauth_issue_refresh_tokens   = true
  oauth_refresh_token_validity = 432000 # 5日
  oauth_use_secondary_roles    = "NONE"
  oauth_roles_ar_to_fr_set     = ["SR_TABLEAU"]
}

# Tableau Cloud用カスタムOAuth統合（追加）
resource "snowflake_oauth_integration_for_custom_clients" "tableau_cloud_custom" {
  provider = snowflake.fr_security_manager

  name                         = "TABLEAU_CLOUD_CUSTOM_OAUTH"
  oauth_client_type            = "PUBLIC"
  oauth_redirect_uri           = "https://us-west-2b.online.tableau.com/auth/oauth_redirect"
  enabled                      = true
  oauth_issue_refresh_tokens   = true
  oauth_refresh_token_validity = 432000
  oauth_enforce_pkce           = true
  comment                      = "Custom OAuth for Tableau Cloud"
}

# カスタム統合の権限付与
resource "snowflake_grant_privileges_to_account_role" "tableau_custom_oauth_usage" {
  provider = snowflake.fr_security_manager

  privileges        = ["USAGE"]
  account_role_name = "SR_TABLEAU"
  on_account_object {
    object_type = "INTEGRATION"
    object_name = snowflake_oauth_integration_for_custom_clients.tableau_cloud_custom.name
  }
}

# Tableau Desktop用OAuth統合
module "tableau_desktop_oauth_integration" {
  source = "../../modules/oauth_integration_for_partner_applications"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  name                         = "TABLEAU_DESKTOP_SECURITY_INTEGRATION"
  oauth_client                 = "TABLEAU_DESKTOP"
  comment                      = "for tableau desktop oauth"
  enabled                      = true
  oauth_issue_refresh_tokens   = true
  oauth_refresh_token_validity = 36000 # 10時間
  oauth_use_secondary_roles    = "NONE"
}
