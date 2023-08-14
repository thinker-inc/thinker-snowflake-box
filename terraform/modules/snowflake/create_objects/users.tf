# userを作成
resource "snowflake_user" "users" {
  for_each = {
    for user in var.users : user.name => {
      name                    = user.name
      comment                 = contains(keys(user), "comment") ? user.comment : ""
      disabled                = contains(keys(user), "disabled") ? user.disabled : false
      email                   = contains(keys(user), "email") ? user.email : null
      first_name              = contains(keys(user), "first_name") ? user.first_name : null
      last_name               = contains(keys(user), "last_name") ? user.last_name : null
      must_change_password    = contains(keys(user), "must_change_password") ? user.must_change_password : true
      password                = contains(keys(user), "password") ? user.password : null
      }
  }
  name                    = upper(each.value.name)

  comment                 = each.value.comment
  disabled                = each.value.disabled
  email                   = each.value.email
  first_name              = each.value.first_name
  last_name               = each.value.last_name
  must_change_password    = each.value.must_change_password
  password                = each.value.password
}