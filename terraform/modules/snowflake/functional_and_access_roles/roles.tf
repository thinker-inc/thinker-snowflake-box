# Roleを作成
resource "snowflake_role" "roles" {
  for_each = {
    for role in concat(var.functional_roles, var.access_roles) :
    role.name => role
  }
  
  name    = each.value.name
  comment = each.value.comment
}

resource "snowflake_user" "users" {
  for_each = {
    for user in concat(var.users) :
    user.name => user
  }
  
  name    = each.value.name
  login_name = each.value.login_name
  comment = each.value.comment
}