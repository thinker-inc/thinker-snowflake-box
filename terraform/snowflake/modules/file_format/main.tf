# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/storage_integration
resource "snowflake_file_format" "this" {

  name                         = var.name
  database                     = var.database
  schema                       = var.schema
  format_type                  = var.format_type
  field_delimiter              = var.field_delimiter
  encoding                     = var.encoding
  field_optionally_enclosed_by = var.field_optionally_enclosed_by
  parse_header                 = var.parse_header
  skip_header                  = var.skip_header
  comment                      = var.comment
}

# 作成したファイルフォーマットを使用する権限を付与
resource "snowflake_grant_privileges_to_account_role" "file_format_grant" {
  for_each = var.file_format_roles_ar_to_fr_set

  privileges        = ["USAGE"]
  account_role_name = each.value
  on_schema_object {
    object_type = "FILE FORMAT"
    object_name = snowflake_file_format.this.fully_qualified_name
  }
}
