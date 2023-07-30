resource "snowflake_database" "databases" {
  for_each = {
    for database in var.databases :
    database.name => database
  }
  name                  = upper("${each.value.name}")
  comment               = each.value.comment
  data_retention_time_in_days = each.value.data_retention_time_in_days
}

resource "snowflake_schema" "schemas" {
  for_each = {
    for schema in var.schemas :
    schema.name => schema
  }
  database              = upper("${each.value.database}")
  name                  = upper("${terraform.workspace}_${each.value.schema}")
  comment               = each.value.comment
}