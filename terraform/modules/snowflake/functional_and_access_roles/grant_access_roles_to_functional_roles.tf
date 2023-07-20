# Access role を Functional role に grant する
resource "snowflake_role_grants" "access_role_to_functional_role_grants" {
  for_each = {
    for grant in var.grant_access_roles_to_functional_roles : grant.access_role => {
      access_role      = grant.access_role
      functional_roles = grant.functional_roles
    }
  }

  role_name = each.value.access_role
  roles     = each.value.functional_roles
}
