##################################
### create stage
##################################
resource "snowflake_stage" "stages" {
  for_each = {
    for stage in var.stages : stage.name => stage
  }
  name        = upper(each.value.stage_name)
  database    = upper("${terraform.workspace}_${each.value.database}")
  schema      = upper("${terraform.workspace}_${each.value.schema}")

  copy_options  = contains(keys(each.value), "copy_options") ? each.value.copy_options : "ABORT_STATEMENT"
  comment       = contains(keys(each.value), "comment") ? each.value.comment : ""
  directory     = contains(keys(each.value), "directory") ? each.value.directory : null
  encryption    = contains(keys(each.value), "encryption") ? each.value.encryption : "NONE"
  file_format   = contains(keys(each.value), "file_format") ? each.value.file_format : "AUTO"

  snowflake_iam_user     = contains(keys(each.value), "snowflake_iam_user") ? each.value.snowflake_iam_user : null
  aws_external_id        = contains(keys(each.value), "aws_external_id") ? each.value.aws_external_id : null
  storage_integration    = contains(keys(each.value), "storage_integration") ? each.value.storage_integration : null
  url                    = contains(keys(each.value), "url") ? each.value.url : null

  depends_on = [
    snowflake_database.databases,
    snowflake_schema.schemas,
    snowflake_file_format.file_formats
  ]
}
