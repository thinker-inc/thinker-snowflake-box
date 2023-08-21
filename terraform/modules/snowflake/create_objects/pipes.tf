##################################
### create pipe
##################################
resource "snowflake_pipe" "pipes" {
  for_each = {
    for pipe in var.pipes : pipe.name => pipe if pipe.type == "S3"
  }
  copy_statement  = each.value.copy_statement
  database        = upper("${terraform.workspace}_${each.value.database}")
  schema          = upper("${terraform.workspace}_${each.value.schema}")
  name            = upper(each.value.pipe_name)

  auto_ingest       = contains(keys(each.value), "auto_ingest") ? each.value.auto_ingest : true
  comment           = contains(keys(each.value), "comment") ? each.value.comment : ""
  aws_sns_topic_arn = contains(keys(each.value), "aws_sns_topic_arn") ? each.value.aws_sns_topic_arn : null
  integration       = contains(keys(each.value), "each.value.integration") ? each.value.integration : null
  error_integration = contains(keys(each.value), "error_integration") ? each.value.error_integration : null

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}