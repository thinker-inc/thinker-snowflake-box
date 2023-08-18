# create s3 integrations
resource "snowflake_storage_integration" "integration_s3" {
  for_each = {
    for integration in var.storage_integrations : integration.name => integration if integration.storage_provider == "S3"
  }
  name                      = upper(each.value.name)
  storage_allowed_locations = each.value.storage_allowed_locations
  storage_provider          = each.value.storage_provider

  comment                   = contains(keys(each.value), "comment") ? each.value.comment : ""

  storage_aws_object_acl    = each.value.storage_aws_object_acl
  storage_aws_role_arn      = each.value.storage_aws_role_arn
}

# create GCS integrations
resource "snowflake_storage_integration" "integration_gcs" {
  for_each = {
    for integration in var.storage_integrations : integration.name => integration if integration.storage_provider == "GCS"
  }
  name                      = upper(each.value.name)
  storage_allowed_locations = each.value.storage_allowed_locations
  storage_provider          = each.value.storage_provider

  comment                   = contains(keys(each.value), "comment") ? each.value.comment : ""
}

# create AZURE integrations
resource "snowflake_storage_integration" "integration_azure" {
  for_each = {
    for integration in var.storage_integrations : integration.name => integration if integration.storage_provider == "AZURE"
  }
  name                      = upper(each.value.name)
  storage_allowed_locations = each.value.storage_allowed_locations
  storage_provider          = each.value.storage_provider

  comment                   = contains(keys(each.value), "comment") ? each.value.comment : ""

  azure_tenant_id           = each.value.azure_tenant_id
}