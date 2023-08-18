# file formatの作成
# CSV file format
resource "snowflake_file_format" "csv_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => fileformat if fileformat.format_type == "CSV"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "CSV"

  binary_format                  = contains(keys(each.value), "binary_format") ? each.value.binary_format : "HEX"
  compression                    = contains(keys(each.value), "compression") ? each.value.compression : "AUTO"
  date_format                    = contains(keys(each.value), "date_format") ? each.value.date_format : "AUTO"
  empty_field_as_null            = contains(keys(each.value), "empty_field_as_null") ? each.value.empty_field_as_null : false
  encoding                       = contains(keys(each.value), "encoding") ? each.value.encoding : "UTF8"
  error_on_column_count_mismatch = contains(keys(each.value), "error_on_column_count_mismatch") ? each.value.error_on_column_count_mismatch : false
  escape                         = contains(keys(each.value), "escape") ? each.value.escape : "NONE"
  escape_unenclosed_field        = contains(keys(each.value), "escape_unenclosed_field") ? each.value.escape_unenclosed_field : "\\"
  field_delimiter                = contains(keys(each.value), "field_delimiter") ? each.value.field_delimiter : ","
  field_optionally_enclosed_by   = contains(keys(each.value), "field_optionally_enclosed_by") ? each.value.field_optionally_enclosed_by : "NONE"
  null_if                        = contains(keys(each.value), "null_if") ? each.value.null_if : ["\\N"]
  replace_invalid_characters     = contains(keys(each.value), "replace_invalid_characters") ? each.value.replace_invalid_characters : false
  skip_blank_lines               = contains(keys(each.value), "skip_blank_lines") ? each.value.skip_blank_lines : false
  skip_byte_order_mark           = contains(keys(each.value), "skip_byte_order_mark") ? each.value.skip_byte_order_mark : false
  skip_header                    = contains(keys(each.value), "skip_header") ? each.value.skip_header : 0
  time_format                    = contains(keys(each.value), "time_format") ? each.value.time_format : "AUTO"
  timestamp_format               = contains(keys(each.value), "timestamp_format") ? each.value.timestamp_format : "AUTO"
  trim_space                     = contains(keys(each.value), "trim_space") ? each.value.trim_space : false

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# JSON file format
resource "snowflake_file_format" "json_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => fileformat if fileformat.format_type == "JSON"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "JSON"

  binary_format                  = contains(keys(each.value), "binary_format") ? each.value.binary_format : "HEX"
  compression                    = contains(keys(each.value), "compression") ? each.value.compression : "AUTO"
  date_format                    = contains(keys(each.value), "date_format") ? each.value.date_format : "AUTO"
  null_if                        = contains(keys(each.value), "null_if") ? each.value.null_if : ["\\N"]
  replace_invalid_characters     = contains(keys(each.value), "replace_invalid_characters") ? each.value.replace_invalid_characters : false
  time_format                    = contains(keys(each.value), "time_format") ? each.value.time_format : "AUTO"
  timestamp_format               = contains(keys(each.value), "timestamp_format") ? each.value.timestamp_format : "AUTO"
  trim_space                     = contains(keys(each.value), "trim_space") ? each.value.trim_space : false

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# AVRO file format
resource "snowflake_file_format" "avro_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => fileformat if fileformat.format_type == "AVRO"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "AVRO"

  compression = contains(keys(each.value), "compression") ? each.value.compression : "AUTO"
  null_if     = contains(keys(each.value), "null_if") ? each.value.null_if : ["\\N"]
  trim_space  = contains(keys(each.value), "trim_space") ? each.value.trim_space : false

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# ORC file format
resource "snowflake_file_format" "orc_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => fileformat if fileformat.format_type == "ORC"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "ORC"

  null_if     = contains(keys(each.value), "null_if") ? each.value.null_if : ["\\N"]
  trim_space  = contains(keys(each.value), "trim_space") ? each.value.trim_space : false

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# PARQUET file format
resource "snowflake_file_format" "parquet_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => fileformat if fileformat.format_type == "PARQUET"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "PARQUET"

  binary_as_text  = contains(keys(each.value), "binary_as_text") ? each.value.binary_as_text : true
  compression     = contains(keys(each.value), "compression") ? each.value.compression : "AUTO"
  null_if         = contains(keys(each.value), "null_if") ? each.value.null_if : ["\\N"]
  trim_space      = contains(keys(each.value), "trim_space") ? each.value.trim_space : false

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# XML file format
resource "snowflake_file_format" "xml_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => fileformat if fileformat.format_type == "XML"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "XML"

  compression             = contains(keys(each.value), "compression") ? each.value.compression : "AUTO"
  disable_auto_convert    = contains(keys(each.value), "disable_auto_convert") ? each.value.disable_auto_convert : false
  disable_snowflake_data  = contains(keys(each.value), "disable_snowflake_data") ? each.value.disable_snowflake_data : false
  ignore_utf8_errors      = contains(keys(each.value), "ignore_utf8_errors") ? each.value.ignore_utf8_errors : false
  preserve_space          = contains(keys(each.value), "preserve_space") ? each.value.preserve_space : false
  skip_byte_order_mark    = contains(keys(each.value), "skip_byte_order_mark") ? each.value.skip_byte_order_mark : true
  strip_outer_element     = contains(keys(each.value), "strip_outer_element") ? each.value.strip_outer_element : false

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}