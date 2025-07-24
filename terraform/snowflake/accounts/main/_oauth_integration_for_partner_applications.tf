# ########################
# # oauth integration for partner applications
# https://docs.snowflake.com/ja/sql-reference/sql/create-security-integration-oauth-snowflake
# https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/oauth_integration_for_partner_applications
# ########################

# tableau cloud oauth
module "account_oauth_integration_for_partner_applications" {
  source = "../../modules/oauth_integration_for_partner_applications"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  name         = "TABLEAU_CLOUD_SECURITY_INTEGRATION"
  oauth_client = "TABLEAU_SERVER"
  comment      = "for tableau cloud oauth"

}

# Google Sheets専用 Tableau Cloud OAuth
module "google_sheets_tableau_oauth_integration" {
  source = "../../modules/oauth_integration_for_partner_applications"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  name         = "GOOGLE_SHEETS_TABLEAU_CLOUD_INTEGRATION"
  oauth_client = "TABLEAU_SERVER"
  comment      = "Google Sheets data access for Tableau Cloud"
}