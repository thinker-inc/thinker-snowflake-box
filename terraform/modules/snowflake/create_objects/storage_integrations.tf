##################################
### create integrations
##################################
resource "snowflake_storage_integration" "integration" {
  for_each = {
    for integration in var.storage_integrations : integration.name => integration
  }
  name                      = upper(each.value.name)
  storage_allowed_locations = each.value.storage_allowed_locations
  storage_provider          = each.value.storage_provider

  comment                   = contains(keys(each.value), "comment") ? each.value.comment : ""

  azure_tenant_id           = contains(keys(each.value), "azure_tenant_id") ? each.value.azure_tenant_id : null
  storage_aws_object_acl    = contains(keys(each.value), "storage_aws_object_acl") ? each.value.storage_aws_object_acl : null
  storage_aws_role_arn      = contains(keys(each.value), "storage_aws_role_arn") ? each.value.storage_aws_role_arn : null
  storage_blocked_locations = contains(keys(each.value), "storage_blocked_locations") ? each.value.storage_blocked_locations : null
}