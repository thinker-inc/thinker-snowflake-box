##################################
### on account privileges
##################################
resource "snowflake_grant_privileges_to_account_role" "apply_authentication_policy" {
  privileges        = ["APPLY AUTHENTICATION POLICY"]
  on_account        = true
  account_role_name = var.apply_authentication_policy_role_name
}

resource "snowflake_grant_privileges_to_account_role" "create_network_policy" {
  privileges        = ["CREATE NETWORK POLICY"]
  on_account        = true
  account_role_name = var.create_network_policy_role_name
}
