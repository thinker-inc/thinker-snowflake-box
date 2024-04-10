#################################
## grant account role to user
#################################
resource "snowflake_grant_account_role" "functional_roles_to_user" {
  for_each = {
    for grant in var.grant_functional_roles_to_users : grant.index => grant
  }

  role_name = upper("${each.value.role_name}")
  user_name = upper("${each.value.user_name}")

  depends_on = [snowflake_role.roles]
}
