# on Database
resource "snowflake_database_grant" "on_database_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      database_name = grant.parameter.database_name
      privilege     = grant.parameter.privilege
      roles         = grant.roles
    }
    if grant.type == "DATABASE"
  }
  database_name = each.value.database_name
  privilege     = each.value.privilege
  roles         = each.value.roles
  # 先に存在しなければならないが、参照していないので依存関係を付ける
  depends_on = [snowflake_role.roles]
}

# on Schema
resource "snowflake_schema_grant" "on_schema_grant" {
  for_each = {
    for grant in var.grant_on_object_to_access_role : grant.name => {
      schema_name   = grant.parameter.schema_name
      database_name = grant.parameter.database_name
      privilege     = grant.parameter.privilege
      roles         = grant.roles
    }
    if grant.type == "SCHEMA"
  }
  database_name = each.value.database_name
  schema_name   = each.value.schema_name
  privilege     = each.value.privilege
  roles         = each.value.roles
  # 先に存在しなければならないが、参照していないので依存関係を付ける
  depends_on = [snowflake_role.roles]
}

# # on (future) table
# resource "snowflake_table_grant" "on_table" {
#   for_each = {
#     for grant in var.grant_on_object_to_access_role : grant.name => {
#       database_name = grant.parameter.database_name
#       schema_name   = grant.parameter.schema_name
#       table_name    = lookup(grant.parameter, "table_name", null)
#       privilege     = grant.parameter.privilege
#       on_future     = lookup(grant.parameter, "on_future", null)
#       roles         = grant.roles
#     }
#     if grant.type == "TABLE"
#   }
#   database_name = each.value.database_name
#   schema_name   = each.value.schema_name
#   table_name    = each.value.table_name
#   privilege     = each.value.privilege
#   on_future     = each.value.on_future
#   roles         = each.value.roles
#   # 先に存在しなければならないが、参照していないので依存関係を付ける
#   depends_on = [snowflake_role.roles]
# }

# # on warehouse
# resource "snowflake_warehouse_grant" "on_warehouse_grant" {
#   for_each = {
#     for grant in var.grant_on_object_to_access_role : grant.name => {
#       warehouse_name = grant.parameter.warehouse_name
#       privilege      = grant.parameter.privilege
#       roles          = grant.roles
#     }
#     if grant.type == "WAREHOUSE"
#   }
#   warehouse_name = each.value.warehouse_name
#   privilege      = each.value.privilege
#   roles          = each.value.roles
#   # 先に存在しなければならないが、参照していないので依存関係を付ける
#   depends_on = [snowflake_role.roles]
# }