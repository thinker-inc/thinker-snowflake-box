########################
# Database
########################
module "staging_db" {
  source = "../../modules/access_role_and_database"
  providers = {
    snowflake = snowflake.terraform
  }

  database_name               = "STAGING"
  comment                     = "Database to store data with minimal transformation from raw data"
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

  etl_tool_ar_to_fr_set = [
    module.fr_etl_tool_import.name
  ]
}

########################
# Schema
########################
module "staging_db_service_a_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "SERVICE_A"
  database_name               = module.staging_db.name
  comment                     = "Schema to store data with minimal transformation from raw data of service A"
  data_retention_time_in_days = 1

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name,
  ]

  read_only_ar_to_fr_set = [
    module.fr_analyst.name
  ]

  etl_tool_ar_to_fr_set = [
    module.fr_etl_tool_import.name
  ]
}

module "staging_db_service_b_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "SERVICE_B"
  database_name               = module.staging_db.name
  comment                     = "Schema to store data with minimal transformation from raw data of service B"
  data_retention_time_in_days = 1

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name,
  ]

  read_only_ar_to_fr_set = [
    module.fr_analyst.name
  ]

  etl_tool_ar_to_fr_set = [
    module.fr_etl_tool_import.name
  ]
}
