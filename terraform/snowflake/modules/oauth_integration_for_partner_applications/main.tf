# https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/oauth_integration_for_partner_applications
# snowflake_oauth_integration_for_partner_applications
resource "snowflake_oauth_integration_for_partner_applications" "this" {
  name                         = var.name
  oauth_client                 = var.oauth_client
  enabled                      = var.enabled
  oauth_issue_refresh_tokens   = var.oauth_issue_refresh_tokens
  oauth_refresh_token_validity = var.oauth_refresh_token_validity
  oauth_use_secondary_roles    = var.oauth_use_secondary_roles
  blocked_roles_list           = var.blocked_roles_list
  comment                      = var.comment
}
