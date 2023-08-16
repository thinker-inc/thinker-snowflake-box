# create pipe
resource "snowflake_pipe" "pipes_s3" {
  for_each = {
    for pipe in var.pipes : pipe.name => {
      copy_statement  = pipe.copy_statement
      database        = pipe.database
      schema          = pipe.schema
      pipe_name       = pipe.pipe_name

      auto_ingest       = contains(keys(pipe), "auto_ingest") ? pipe.auto_ingest : true
      comment           = contains(keys(pipe), "comment") ? pipe.comment : ""
      aws_sns_topic_arn = pipe.aws_sns_topic_arn
      # error_integration = pipe.error_integration
    }
    if pipe.type == "S3"
  }
  copy_statement  = each.value.copy_statement
  database        = upper(each.value.database)
  schema          = upper("${terraform.workspace}_${each.value.schema}")
  name            = upper(each.value.pipe_name)

  auto_ingest       = each.value.auto_ingest
  comment           = each.value.comment
  aws_sns_topic_arn = each.value.aws_sns_topic_arn
  # error_integration = each.value.error_integration

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# create pipe
resource "snowflake_pipe" "pipes_gcs_or_azure" {
  for_each = {
    for pipe in var.pipes : pipe.name => {
      copy_statement  = pipe.copy_statement
      database        = pipe.database
      schema          = pipe.schema
      pipe_name       = pipe.pipe_name

      auto_ingest     = contains(keys(pipe), "auto_ingest") ? pipe.auto_ingest : true
      comment         = contains(keys(pipe), "comment") ? pipe.comment : ""
      integration     = pipe.integration
      # error_integration = pipe.error_integration
    }
    if pipe.type == "GCS" || pipe.type == "Azure"
  }
  copy_statement  = each.value.copy_statement
  database        = upper(each.value.database)
  schema          = upper("${terraform.workspace}_${each.value.schema}")
  name            = upper(each.value.pipe_name)

  auto_ingest     = each.value.auto_ingest
  comment         = each.value.comment
  integration     = each.value.integration
  # error_integration = each.value.error_integration

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}