# userを作成
resource "snowflake_user" "users" {
  for_each = {
    for user in var.users : user.name => user
  }
  name                    = upper(each.value.name)

  comment                 = contains(keys(each.value), "comment") ? each.value.comment : ""
  disabled                = contains(keys(each.value), "disabled") ? each.value.disabled : false
  email                   = contains(keys(each.value), "email") ? each.value.email : null
  first_name              = contains(keys(each.value), "first_name") ? each.value.first_name : null
  last_name               = contains(keys(each.value), "last_name") ? each.value.last_name : null
  must_change_password    = contains(keys(each.value), "must_change_password") ? each.value.must_change_password : true
  password                = contains(keys(each.value), "password") ? each.value.password : null
}