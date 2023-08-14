# create database
resource "snowflake_database" "databases" {
  for_each = {
    for database in var.databases : database.name => {
      name                        = database.name
      comment                     = contains(keys(database), "comment") ? database.comment : ""
      data_retention_time_in_days = contains(keys(database), "data_retention_time_in_days") ? database.data_retention_time_in_days : 1
      is_transient                = contains(keys(database), "is_transient") ? database.is_transient : false
    }
  }
  name                        = upper("${each.value.name}")
  comment                     = each.value.comment
  data_retention_time_in_days = each.value.data_retention_time_in_days
  is_transient                = each.value.is_transient
}

resource "snowflake_schema" "schemas" {
  for_each = {
    for schema in var.schemas : schema.name => {
      database            = schema.database
      schema              = schema.schema

      comment             = contains(keys(schema), "comment") ? schema.comment : ""
      data_retention_days = contains(keys(schema), "data_retention_days") ? schema.data_retention_days : 1
      is_managed          = contains(keys(schema), "is_managed") ? schema.is_managed : true
      is_transient        = contains(keys(schema), "is_transient") ? schema.is_transient : false
    }
  }
  database            = upper("${each.value.database}")
  name                = upper("${terraform.workspace}_${each.value.schema}")
  comment             = each.value.comment

  data_retention_days = each.value.data_retention_days
  is_managed          = each.value.is_managed
  is_transient        = each.value.is_transient

  depends_on = [snowflake_database.databases]
}