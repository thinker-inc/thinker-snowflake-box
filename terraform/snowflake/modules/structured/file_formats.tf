##################################
### create fileformat
##################################
resource "snowflake_file_format" "file_formats" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => fileformat
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper("${terraform.workspace}_${each.value.database}")
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = each.value.format_type

  binary_as_text                 = contains(keys(each.value), "binary_as_text") ? each.value.binary_as_text : null
  binary_format                  = contains(keys(each.value), "binary_format") ? each.value.binary_format : null
  compression                    = contains(keys(each.value), "compression") ? each.value.compression : null
  date_format                    = contains(keys(each.value), "date_format") ? each.value.date_format : null
  disable_auto_convert           = contains(keys(each.value), "disable_auto_convert") ? each.value.disable_auto_convert : null
  disable_snowflake_data         = contains(keys(each.value), "disable_snowflake_data") ? each.value.disable_snowflake_data : null
  empty_field_as_null            = contains(keys(each.value), "empty_field_as_null") ? each.value.empty_field_as_null : null
  encoding                       = contains(keys(each.value), "encoding") ? each.value.encoding : null
  error_on_column_count_mismatch = contains(keys(each.value), "error_on_column_count_mismatch") ? each.value.error_on_column_count_mismatch : null
  escape                         = contains(keys(each.value), "escape") ? each.value.escape : null
  escape_unenclosed_field        = contains(keys(each.value), "escape_unenclosed_field") ? each.value.escape_unenclosed_field : null
  field_delimiter                = contains(keys(each.value), "field_delimiter") ? each.value.field_delimiter : null
  field_optionally_enclosed_by   = contains(keys(each.value), "field_optionally_enclosed_by") ? each.value.field_optionally_enclosed_by : null
  ignore_utf8_errors             = contains(keys(each.value), "ignore_utf8_errors") ? each.value.ignore_utf8_errors : null
  null_if                        = contains(keys(each.value), "null_if") ? each.value.null_if : null
  preserve_space                 = contains(keys(each.value), "preserve_space") ? each.value.preserve_space : null
  replace_invalid_characters     = contains(keys(each.value), "replace_invalid_characters") ? each.value.replace_invalid_characters : null
  skip_blank_lines               = contains(keys(each.value), "skip_blank_lines") ? each.value.skip_blank_lines : null
  skip_byte_order_mark           = contains(keys(each.value), "skip_byte_order_mark") ? each.value.skip_byte_order_mark : null
  skip_header                    = contains(keys(each.value), "skip_header") ? each.value.skip_header : null
  strip_outer_element            = contains(keys(each.value), "strip_outer_element") ? each.value.strip_outer_element : null
  time_format                    = contains(keys(each.value), "time_format") ? each.value.time_format : null
  timestamp_format               = contains(keys(each.value), "timestamp_format") ? each.value.timestamp_format : null
  trim_space                     = contains(keys(each.value), "trim_space") ? each.value.trim_space : null

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}