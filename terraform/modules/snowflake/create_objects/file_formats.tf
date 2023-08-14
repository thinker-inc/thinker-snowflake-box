# file formatの作成
# CSV file format
resource "snowflake_file_format" "csv_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => {
      name        = fileformat.name
      database    = fileformat.database
      schema      = fileformat.schema

      binary_format                  = contains(keys(fileformat), "binary_format") ? fileformat.binary_format : "HEX"
      compression                    = contains(keys(fileformat), "compression") ? fileformat.compression : "AUTO"
      date_format                    = contains(keys(fileformat), "date_format") ? fileformat.date_format : "AUTO"
      empty_field_as_null            = contains(keys(fileformat), "empty_field_as_null") ? fileformat.empty_field_as_null : false
      encoding                       = contains(keys(fileformat), "encoding") ? fileformat.encoding : "UTF8"
      error_on_column_count_mismatch = contains(keys(fileformat), "error_on_column_count_mismatch") ? fileformat.error_on_column_count_mismatch : false
      escape                         = contains(keys(fileformat), "escape") ? fileformat.escape : "NONE"
      escape_unenclosed_field        = contains(keys(fileformat), "escape_unenclosed_field") ? fileformat.escape_unenclosed_field : "\\"
      field_delimiter                = contains(keys(fileformat), "field_delimiter") ? fileformat.field_delimiter : ","
      field_optionally_enclosed_by   = contains(keys(fileformat), "field_optionally_enclosed_by") ? fileformat.field_optionally_enclosed_by : "NONE"
      null_if                        = contains(keys(fileformat), "null_if") ? fileformat.null_if : ["\\N"]
      replace_invalid_characters     = contains(keys(fileformat), "replace_invalid_characters") ? fileformat.replace_invalid_characters : false
      skip_blank_lines               = contains(keys(fileformat), "skip_blank_lines") ? fileformat.skip_blank_lines : false
      skip_byte_order_mark           = contains(keys(fileformat), "skip_byte_order_mark") ? fileformat.skip_byte_order_mark : false
      skip_header                    = contains(keys(fileformat), "skip_header") ? fileformat.skip_header : 0
      time_format                    = contains(keys(fileformat), "time_format") ? fileformat.time_format : "AUTO"
      timestamp_format               = contains(keys(fileformat), "timestamp_format") ? fileformat.timestamp_format : "AUTO"
      trim_space                     = contains(keys(fileformat), "trim_space") ? fileformat.trim_space : false
    }
    if fileformat.format_type == "CSV"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "CSV"

  binary_format                  = each.value.binary_format
  compression                    = each.value.compression
  date_format                    = each.value.date_format
  empty_field_as_null            = each.value.empty_field_as_null
  encoding                       = each.value.encoding
  error_on_column_count_mismatch = each.value.error_on_column_count_mismatch
  escape                         = each.value.escape
  escape_unenclosed_field        = each.value.escape_unenclosed_field
  field_delimiter                = each.value.field_delimiter
  field_optionally_enclosed_by   = each.value.field_optionally_enclosed_by
  null_if                        = each.value.null_if
  replace_invalid_characters     = each.value.replace_invalid_characters
  skip_blank_lines               = each.value.skip_blank_lines
  skip_byte_order_mark           = each.value.skip_byte_order_mark
  skip_header                    = each.value.skip_header
  time_format                    = each.value.time_format
  timestamp_format               = each.value.timestamp_format
  trim_space                     = each.value.trim_space

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# JSON file format
resource "snowflake_file_format" "json_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => {
      name        = fileformat.name
      database    = fileformat.database
      schema      = fileformat.schema

      binary_format                  = contains(keys(fileformat), "binary_format") ? fileformat.binary_format : "HEX"
      compression                    = contains(keys(fileformat), "compression") ? fileformat.compression : "AUTO"
      date_format                    = contains(keys(fileformat), "date_format") ? fileformat.date_format : "AUTO"
      null_if                        = contains(keys(fileformat), "null_if") ? fileformat.null_if : ["\\N"]
      replace_invalid_characters     = contains(keys(fileformat), "replace_invalid_characters") ? fileformat.replace_invalid_characters : false
      time_format                    = contains(keys(fileformat), "time_format") ? fileformat.time_format : "AUTO"
      timestamp_format               = contains(keys(fileformat), "timestamp_format") ? fileformat.timestamp_format : "AUTO"
      trim_space                     = contains(keys(fileformat), "trim_space") ? fileformat.trim_space : false
    }
    if fileformat.format_type == "JSON"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "JSON"

  binary_format                  = each.value.binary_format
  compression                    = each.value.compression
  date_format                    = each.value.date_format
  null_if                        = each.value.null_if
  replace_invalid_characters     = each.value.replace_invalid_characters
  time_format                    = each.value.time_format
  timestamp_format               = each.value.timestamp_format
  trim_space                     = each.value.trim_space

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# AVRO file format
resource "snowflake_file_format" "avro_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => {
      name        = fileformat.name
      database    = fileformat.database
      schema      = fileformat.schema

      compression = contains(keys(fileformat), "compression") ? fileformat.compression : "AUTO"
      null_if     = contains(keys(fileformat), "null_if") ? fileformat.null_if : ["\\N"]
      trim_space  = contains(keys(fileformat), "trim_space") ? fileformat.trim_space : false
    }
    if fileformat.format_type == "AVRO"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "AVRO"

  compression = each.value.compression
  null_if     = each.value.null_if
  trim_space  = each.value.trim_space

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# ORC file format
resource "snowflake_file_format" "orc_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => {
      name        = fileformat.name
      database    = fileformat.database
      schema      = fileformat.schema

      null_if    = contains(keys(fileformat), "null_if") ? fileformat.null_if : ["\\N"]
      trim_space = contains(keys(fileformat), "trim_space") ? fileformat.trim_space : false
    }
    if fileformat.format_type == "ORC"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "ORC"

  null_if     = each.value.null_if
  trim_space  = each.value.trim_space

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# PARQUET file format
resource "snowflake_file_format" "parquet_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => {
      name        = fileformat.name
      database    = fileformat.database
      schema      = fileformat.schema

      binary_as_text  = contains(keys(fileformat), "binary_as_text") ? fileformat.binary_as_text : true
      compression     = contains(keys(fileformat), "compression") ? fileformat.compression : "AUTO"
      null_if         = contains(keys(fileformat), "null_if") ? fileformat.null_if : ["\\N"]
      trim_space      = contains(keys(fileformat), "trim_space") ? fileformat.trim_space : false
    }
    if fileformat.format_type == "PARQUET"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "PARQUET"

  binary_as_text  = each.value.binary_as_text
  compression     = each.value.compression
  null_if         = each.value.null_if
  trim_space      = each.value.trim_space

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}

# XML file format
resource "snowflake_file_format" "xml_file_format" {
  for_each = {
    for fileformat in var.fileformats : fileformat.name => {
      name        = fileformat.name
      database    = fileformat.database
      schema      = fileformat.schema

      compression             = contains(keys(fileformat), "compression") ? fileformat.compression : "AUTO"
      disable_auto_convert    = contains(keys(fileformat), "disable_auto_convert") ? fileformat.disable_auto_convert : false
      disable_snowflake_data  = contains(keys(fileformat), "disable_snowflake_data") ? fileformat.disable_snowflake_data : false
      ignore_utf8_errors      = contains(keys(fileformat), "ignore_utf8_errors") ? fileformat.ignore_utf8_errors : false
      preserve_space          = contains(keys(fileformat), "preserve_space") ? fileformat.preserve_space : false
      skip_byte_order_mark    = contains(keys(fileformat), "skip_byte_order_mark") ? fileformat.skip_byte_order_mark : true
      strip_outer_element     = contains(keys(fileformat), "strip_outer_element") ? fileformat.strip_outer_element : false
    }
    if fileformat.format_type == "XML"
  }
  name        = upper("${terraform.workspace}_${each.value.name}")
  database    = upper(each.value.database)
  schema      = upper("${terraform.workspace}_${each.value.schema}")
  format_type = "XML"

  compression             = each.value.compression
  disable_auto_convert    = each.value.disable_auto_convert
  disable_snowflake_data  = each.value.disable_snowflake_data
  ignore_utf8_errors      = each.value.ignore_utf8_errors
  preserve_space          = each.value.preserve_space
  skip_byte_order_mark    = each.value.skip_byte_order_mark
  strip_outer_element     = each.value.strip_outer_element

  depends_on = [snowflake_database.databases, snowflake_schema.schemas]
}