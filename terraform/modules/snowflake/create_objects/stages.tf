# create stage
resource "snowflake_stage" "stages" {
  for_each = {
    for stage in var.stages : stage.name => stage #if stage.type == "S3" || stage.type == "GCS" || stage.type == "AZURE"
  }
  name        = upper(each.value.stage_name)
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")

  copy_options  = contains(keys(each.value), "copy_options") ? each.value.copy_options : "ABORT_STATEMENT"
  comment       = contains(keys(each.value), "comment") ? each.value.comment : ""
  encryption    = contains(keys(each.value), "encryption") ? each.value.encryption : "NONE"
  file_format   = contains(keys(each.value), "file_format") ? each.value.file_format : "AUTO"

  storage_integration    = contains(keys(each.value), "storage_integration") ? each.value.storage_integration : null
  url                    = contains(keys(each.value), "url") ? each.value.url : null

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
