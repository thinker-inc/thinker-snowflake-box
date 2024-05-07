########################
# Database
########################
module "mart_db" {
  source = "../../modules/access_role_and_database"
  providers = {
    snowflake = snowflake.terraform
  }

  database_name               = "MART"
  comment                     = "Database that stores data used for reporting and linkage to another tool"
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
module "mart_db_tableau_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name         = "TABLEAU_BI"
  database_name       = module.mart_db.name
  comment             = "Schema that stores data used for reporting and linkage to another tool for TABLEAU"
  data_retention_days = 1

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

module "mart_db_ad_google_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name         = "AD_GOOGLE"
  database_name       = module.mart_db.name
  comment             = "Schema that stores data used for reporting and linkage to another tool for AD Google"
  data_retention_days = 1

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
