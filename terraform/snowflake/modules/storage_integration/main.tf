# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/storage_integration
resource "snowflake_storage_integration" "this" {

  name    = var.storage_integration_name
  comment = var.comment
  type    = var.type
  enabled = var.enabled

  storage_allowed_locations = var.storage_allowed_locations

  storage_provider     = var.storage_provider
  storage_aws_role_arn = var.storage_aws_role_arn
}


# 作成したストレージ統合を使用する権限を付与
resource "snowflake_grant_privileges_to_account_role" "integration_grant" {
  for_each = var.storage_roles_ar_to_fr_set

  privileges        = ["USAGE"]
  account_role_name = each.value
  on_account_object {
    object_type = "INTEGRATION"
    object_name = snowflake_storage_integration.this.name
  }
}
