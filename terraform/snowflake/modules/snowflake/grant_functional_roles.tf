##################################
### Functional role を user　に grant する
##################################
resource "snowflake_role_grants" "functional_roles_to_user" {
  for_each = {
    for grant in var.grant_functional_roles_to_user : grant.name => grant
  }
  role_name = upper("${terraform.workspace}_${each.value.role_name}")
  users     = [for user in each.value.users: upper(user)]

  enable_multiple_grants = true

  depends_on = [ 
    snowflake_user.users,
    snowflake_role.roles
  ]
}