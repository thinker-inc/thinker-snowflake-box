########################
# Storage Integration
# Doc: https://docs.snowflake.com/en/sql-reference/sql/create-storage-integration
########################
# module "s3_storage_integration" {
#   source = "../../modules/storage_integration"
#   providers = {
#     snowflake = snowflake.terraform
#   }
# 
#   storage_integration_name  = "S3_INTEGRATION"
#   comment                   = "DB storage integration."
#   type                      = "EXTERNAL_STAGE"
#   storage_allowed_locations = ["*"]
#   storage_provider          = "S3"
#   storage_aws_role_arn      = "{ARN}"
# 
#   enabled = true
# 
#   storage_roles_ar_to_fr_set = [
#     module.fr_manager.name,
#     module.fr_data_engineer.name
#   ]
# } 
