#################################
## grant account role to account role
#################################
resource "snowflake_grant_account_role" "access_role_to_functional_role_grants" {
  for_each = {
    for grant in var.grant_access_roles_to_functional_roles : grant.index => grant
  }

  role_name        = upper("${each.value.role_name}")
  parent_role_name = upper("${each.value.parent_role_name}")

  depends_on = [snowflake_role.roles]
}
