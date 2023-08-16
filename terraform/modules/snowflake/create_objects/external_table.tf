resource "snowflake_external_table" "external_tables" {
  for_each = {
    for table in var.external_tables : table.name => table
  }

  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  name        = upper(each.value.exteranl_table_name)

  file_format = each.value.file_format
  location    = each.value.location
  pattern     = each.value.pattern


  auto_refresh       = contains(keys(each.value), "auto_refresh") ? each.value.auto_refresh : true
  aws_sns_topic      = contains(keys(each.value), "aws_sns_topic") ? each.value.aws_sns_topic : ""
  comment            = contains(keys(each.value), "comment") ? each.value.comment : ""


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
    snowflake_file_format.csv_file_format,
    snowflake_file_format.json_file_format,
    snowflake_file_format.avro_file_format,
    snowflake_file_format.orc_file_format,
    snowflake_file_format.parquet_file_format,
    snowflake_file_format.xml_file_format
  ]
}
