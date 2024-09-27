##################################
### on account privileges
##################################
# SYSADMINにFunctional Roleをgrant
resource "snowflake_grant_account_role" "grant_to_securityadmin" {
  role_name        = "SECURITYADMIN"
  parent_role_name = var.security_admin_policy_role_name
}

resource "snowflake_grant_privileges_to_account_role" "apply_authentication_policy" {
  privileges        = ["APPLY AUTHENTICATION POLICY"]
  on_account        = true
  account_role_name = var.security_admin_policy_role_name

  depends_on = [snowflake_grant_account_role.grant_to_securityadmin]
}

resource "snowflake_grant_privileges_to_account_role" "create_network_policy" {
  privileges        = ["CREATE NETWORK POLICY"]
  on_account        = true
  account_role_name = var.security_admin_policy_role_name

  depends_on = [snowflake_grant_account_role.grant_to_securityadmin]
}
