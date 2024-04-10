##################################
### Create Database
##################################
resource "snowflake_database" "simple" {
  for_each = {
    for key, database in var.databases : database.name => database
  }

  name                        = upper("${each.value.name}")
  comment                     = contains(keys(each.value), "comment") ? each.value.comment : ""
  data_retention_time_in_days = contains(keys(each.value), "data_retention_time_in_days") ? each.value.data_retention_time_in_days : 1
}

##################################
### Create Schema
##################################
resource "snowflake_schema" "schemas" {
  for_each = {
    for schema in var.schemas : schema.index_name => schema
  }

  name       = upper("${each.value.name}")
  database   = upper("${each.value.database}")
  comment    = contains(keys(each.value), "comment") ? each.value.comment : ""
  depends_on = [snowflake_database.simple]
}
