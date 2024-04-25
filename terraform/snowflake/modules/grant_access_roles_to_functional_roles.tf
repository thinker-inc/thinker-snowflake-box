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

resource "snowflake_grant_account_role" "wh_role_to_sysadmin_grants" {
  #for_each = toset([for role in snowflake_role.roles : role.name])
  for_each = {
    for role in var.grant_access_wh_roles_to_functional_roles : role.index => role
  }

  role_name        = upper("${each.value.role_name}")
  parent_role_name = upper("${each.value.parent_role_name}")

  depends_on = [snowflake_role.roles]
}
