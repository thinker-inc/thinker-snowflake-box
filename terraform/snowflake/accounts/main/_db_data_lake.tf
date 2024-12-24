########################
# Database
########################
module "data_lake_db" {
  source = "../../modules/access_role_and_database"
  providers = {
    snowflake = snowflake.terraform
  }

  database_name               = "DATA_LAKE"
  comment                     = "Database to store loaded raw data"
  data_retention_time_in_days = 1

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name
  ]

  read_only_ar_to_fr_set = [
    module.fr_analyst.name
  ]

  sr_trocco_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_trocco_transform_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}

########################
# Schema
########################
module "data_lake_db_service_a_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                    = "SERVICE_A"
  database_name                  = module.data_lake_db.name
  comment                        = "Schema to store loaded raw data of service A"
  data_retention_time_in_days    = 1
  grant_feature_external_table   = true
  grant_feature_stored_procedure = true

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = [
  ]

  read_only_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name,
    module.fr_analyst.name
  ]

  sr_trocco_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_trocco_transform_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}

# # create Parquet File Format
# module "parquet_file_format" {
#   source = "../../modules/file_format"
#   providers = {
#     snowflake = snowflake.terraform
#   }
# 
#   name        = "PARQUET_FILE_FORMAT"
#   database    = module._data_lake.name
#   schema      = module.data_lake_db_service_a_schema.name
#   format_type = "PARQUET"
#   comment     = "file format for parquet file"
# 
#   file_format_roles_ar_to_fr_set = [
#     module.fr_manager.name,
#     module.fr_data_engineer.name
#   ]
# }
# 
# # Create External Stage
# module "external_stage" {
#   source = "../../modules/stage"
#   providers = {
#     snowflake = snowflake.terraform
#   }
# 
#   name                = "EXTERNAL_STAGE"
#   url                 = "{s3_url}"
#   database            = module._data_lake.name
#   schema              = module.data_lake_db_service_a_schema.name
#   file_format         = "FORMAT_NAME = ${local.parquet_file_format_fullqualified_name}"
#   storage_integration = module.s3_storage_integration.name
#   comment             = "external stage for loading data from s3"
#   directory           = "ENABLE = true"
# 
#   stage_roles_ar_to_fr_set = [
#     module.fr_manager.name,
#     module.fr_data_engineer.name
#   ]
# }

module "data_lake_db_service_b_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                    = "SERVICE_B"
  database_name                  = module.data_lake_db.name
  comment                        = "Schema to store loaded raw data of service B"
  data_retention_time_in_days    = 1
  grant_feature_external_table   = true
  grant_feature_stored_procedure = true

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = [
  ]

  read_only_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_analyst.name,
    module.fr_scientist.name
  ]

  sr_trocco_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_trocco_transform_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}
