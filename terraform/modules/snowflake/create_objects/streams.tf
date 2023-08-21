##################################
### create stream on stage
##################################
resource "snowflake_stream" "stream_on_stage" {
  for_each = {
    for stream in var.streams : stream.name => stream if contains(keys(stream), "on_stage")
  }
  name      = upper(each.value.stream_name)
  database  = upper("${terraform.workspace}_${each.value.database}")
  schema    = upper("${terraform.workspace}_${each.value.schema}")

  on_stage  = upper(each.value.on_stage)
  comment           = contains(keys(each.value), "comment") ? each.value.comment : ""

  append_only       = contains(keys(each.value), "append_only") ? each.value.append_only : false
  insert_only       = contains(keys(each.value), "insert_only") ? each.value.insert_only : false
  show_initial_rows = contains(keys(each.value), "show_initial_rows") ? each.value.show_initial_rows : false

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

##################################
### create stream on table
##################################
resource "snowflake_stream" "stream_on_table" {
  for_each = {
    for stream in var.streams : stream.name => stream if contains(keys(stream), "on_table")
  }
  name      = upper(each.value.stream_name)
  database  = upper("${terraform.workspace}_${each.value.database}")
  schema    = upper("${terraform.workspace}_${each.value.schema}")

  on_table  = upper(each.value.on_table)
  comment           = contains(keys(each.value), "comment") ? each.value.comment : ""

  append_only       = contains(keys(each.value), "append_only") ? each.value.append_only : false
  insert_only       = contains(keys(each.value), "insert_only") ? each.value.insert_only : false
  show_initial_rows = contains(keys(each.value), "show_initial_rows") ? each.value.show_initial_rows : false

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

##################################
### create stream on view
##################################
resource "snowflake_stream" "stream_on_view" {
  for_each = {
    for stream in var.streams : stream.name => stream if contains(keys(stream), "on_view")
  }
  name      = upper(each.value.stream_name)
  database  = upper("${terraform.workspace}_${each.value.database}")
  schema    = upper("${terraform.workspace}_${each.value.schema}")

  on_view   = upper(each.value.on_view)
  comment           = contains(keys(each.value), "comment") ? each.value.comment : ""

  append_only       = contains(keys(each.value), "append_only") ? each.value.append_only : false
  insert_only       = contains(keys(each.value), "insert_only") ? each.value.insert_only : false
  show_initial_rows = contains(keys(each.value), "show_initial_rows") ? each.value.show_initial_rows : false

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}