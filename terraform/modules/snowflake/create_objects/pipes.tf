# create s3 pipe
resource "snowflake_pipe" "pipes_s3" {
  for_each = {
    for pipe in var.pipes : pipe.name => pipe if pipe.type == "S3"
  }
  copy_statement  = each.value.copy_statement
  database        = upper(each.value.database)
  schema          = upper("${terraform.workspace}_${each.value.schema}")
  name            = upper(each.value.pipe_name)

  auto_ingest       = contains(keys(each.value), "auto_ingest") ? each.value.auto_ingest : true
  comment           = contains(keys(each.value), "comment") ? each.value.comment : ""
  aws_sns_topic_arn = each.value.aws_sns_topic_arn
  # error_integration = each.value.error_integration

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# create gcs and azure blob pipe
resource "snowflake_pipe" "pipes_gcs_or_azure" {
  for_each = {
    for pipe in var.pipes : pipe.name => pipe if pipe.type == "GCS" || pipe.type == "AZURE"
  }
  copy_statement  = each.value.copy_statement
  database        = upper(each.value.database)
  schema          = upper("${terraform.workspace}_${each.value.schema}")
  name            = upper(each.value.pipe_name)

  auto_ingest     = contains(keys(each.value), "auto_ingest") ? each.value.auto_ingest : true
  comment         = contains(keys(each.value), "comment") ? each.value.comment : ""
  integration     = each.value.integration
  # error_integration = pipe.error_integration

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}