# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/stage
# Create External Stage
resource "snowflake_stage" "this" {
  name                = var.name
  url                 = var.url
  database            = var.database
  schema              = var.schema
  file_format         = var.file_format
  storage_integration = var.storage_integration
  directory           = var.directory
  comment             = var.comment
}

# 作成したステージを使用する権限を付与
resource "snowflake_grant_privileges_to_account_role" "stage_grant" {
  for_each = var.stage_roles_ar_to_fr_set

  privileges        = ["USAGE"]
  account_role_name = each.value
  on_schema_object {
    object_type = "STAGE"
    object_name = snowflake_stage.this.fully_qualified_name
  }
}
