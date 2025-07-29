# ########################
# # oauth integration for partner applications
# https://docs.snowflake.com/ja/sql-reference/sql/create-security-integration-oauth-snowflake
# https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/oauth_integration_for_partner_applications
# ########################

# Tableau Cloud用OAuth統合
module "tableau_cloud_oauth_integration" {
  source = "../../modules/oauth_integration_for_partner_applications"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  name                         = "TABLEAU_CLOUD_SECURITY_INTEGRATION"
  oauth_client                 = "TABLEAU_SERVER"
  comment                      = "for tableau cloud oauth"
  enabled                      = true
  oauth_issue_refresh_tokens   = true
  oauth_refresh_token_validity = 432000 # 5日
  oauth_use_secondary_roles    = "NONE"
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
