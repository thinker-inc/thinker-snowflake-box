# Access role を Functional role に grant する
resource "snowflake_role_grants" "access_role_to_functional_role_grants" {
  for_each = {
    for grant in var.grant_access_roles_to_functional_roles : grant.name => grant
  }
  role_name   = upper("${terraform.workspace}_${each.value.access_role}")
  roles       = [for functional_role in each.value.functional_roles : upper("${terraform.workspace}_${functional_role}")]
}
