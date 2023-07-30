# userを作成
resource "snowflake_user" "users" {
  for_each = {
    for user in var.users :
    user.name => user
  }
  
  name          = upper(each.value.name)
  login_name    = each.value.login_name
  comment       = each.value.comment
  # password  = each.value.password
  # email     = each.value.email
  # first_name= each.value.first_name
  # last_name = each.value.last_name
  # must_change_password = each.value.must_change_password

  depends_on = [snowflake_role.roles, snowflake_warehouse.warehouses]
}