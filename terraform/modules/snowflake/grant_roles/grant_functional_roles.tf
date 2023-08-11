# Functional role を user　に grant する
resource "snowflake_role_grants" "functional_roles_to_user" {
  for_each = {
    for grant in var.grant_functional_roles_to_user : grant.name => {
      role_name = grant.role_name
      users     = grant.users
    }
  }
  role_name = upper("${terraform.workspace}_${each.value.role_name}")
  users     = [for user in each.value.users: upper(user)]
}