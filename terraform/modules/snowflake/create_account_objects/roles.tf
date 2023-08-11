# Roleを作成
resource "snowflake_role" "roles" {
  for_each = {
    for role in concat(var.functional_roles, var.access_roles) :
    role.name => role
  }

  name      = upper("${terraform.workspace}_${each.value.name}")
  comment   = each.value.comment
}

# SYSADMIN にぶら下げる
resource "snowflake_role_grants" "role_grants" {
  for_each = toset([for role in snowflake_role.roles : role.name])
  role_name = each.key
  roles     = ["SYSADMIN"]
}