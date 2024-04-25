##################################
### create role
##################################
resource "snowflake_role" "roles" {
  for_each = {
    for role in concat(var.functional_roles, var.access_roles) : role.name => role
  }
  name    = upper("${each.value.name}")
  comment = contains(keys(each.value), "comment") ? each.value.comment : ""
}

##################################
### grant SYSADMIN
##################################
resource "snowflake_grant_account_role" "role_to_sysadmin_grants" {
  #for_each = toset([for role in snowflake_role.roles : role.name])
  for_each = {
    for role in concat(var.functional_roles) : role.name => role
  }

  role_name        = upper("${each.value.name}")
  parent_role_name = "SYSADMIN"

  depends_on = [snowflake_warehouse.warehouses, snowflake_role.roles]
}
