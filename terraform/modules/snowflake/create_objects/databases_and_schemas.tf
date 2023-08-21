##################################
### create database
##################################
resource "snowflake_database" "databases" {
  for_each = {
    for database in var.databases : database.name => database
  }
  name                        = upper("${terraform.workspace}_${each.value.name}")
  comment                     = contains(keys(each.value), "comment") ? each.value.comment : ""
  data_retention_time_in_days = contains(keys(each.value), "data_retention_time_in_days") ? each.value.data_retention_time_in_days : 1
  is_transient                = contains(keys(each.value), "is_transient") ? each.value.is_transient : false
}

##################################
### create schema
##################################
resource "snowflake_schema" "schemas" {
  for_each = {
    for schema in var.schemas : schema.name => schema
  }
  database            = upper("${terraform.workspace}_${each.value.database}")
  name                = upper("${terraform.workspace}_${each.value.schema}")

  comment             = contains(keys(each.value), "comment") ? each.value.comment : ""
  data_retention_days = contains(keys(each.value), "data_retention_days") ? each.value.data_retention_days : 1
  is_managed          = contains(keys(each.value), "is_managed") ? each.value.is_managed : true
  is_transient        = contains(keys(each.value), "is_transient") ? each.value.is_transient : false

  depends_on = [snowflake_database.databases]
}