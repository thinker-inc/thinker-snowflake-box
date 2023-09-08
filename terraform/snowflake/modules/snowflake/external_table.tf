##################################
### create external table
##################################
resource "snowflake_external_table" "external_tables" {
  for_each = {
    for table in var.external_tables : table.name => table
  }

  database    = upper("${terraform.workspace}_${each.value.database}")
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  name        = upper(each.value.exteranl_table_name)

  file_format = each.value.file_format
  location    = each.value.location
  pattern     = each.value.pattern


  auto_refresh       = contains(keys(each.value), "auto_refresh") ? each.value.auto_refresh : true
  aws_sns_topic      = contains(keys(each.value), "aws_sns_topic") ? each.value.aws_sns_topic : null
  comment            = contains(keys(each.value), "comment") ? each.value.comment : ""
  copy_grants        = contains(keys(each.value), "copy_grant") ? each.value.copy_grant : false
  partition_by       = contains(keys(each.value), "partition_by") ? each.value.partition_by : null
  refresh_on_create  = contains(keys(each.value), "refresh_on_create") ? each.value.refresh_on_create : true

  dynamic "column" {
    for_each = each.value.column
    content {
      name = column.value.name
      as   = column.value.name
      type = column.value.type
    }
  }

  depends_on = [
    snowflake_database.databases,
    snowflake_schema.schemas,
    snowflake_stage.stages,
    snowflake_file_format.file_formats
  ]
}
