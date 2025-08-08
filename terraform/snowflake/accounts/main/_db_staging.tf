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
    module.fr_analyst.name,
    module.sr_tableau.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}

########################
# Schema
########################
module "staging_db_spreadsheet_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "SPREADSHEET"
  database_name               = module.staging_db.name
  comment                     = "Schema to store data with minimal transformation from raw data of spreadsheet"
  data_retention_time_in_days = 1

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name,
  ]

  read_only_ar_to_fr_set = [
    module.fr_analyst.name,
    module.sr_tableau.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}

module "staging_db_timecrowd_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "TIMECROWD"
  database_name               = module.staging_db.name
  comment                     = "Schema to store data with minimal transformation from raw data of timecrowd"
  data_retention_time_in_days = 1

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name,
  ]

  read_only_ar_to_fr_set = [
    module.fr_analyst.name,
    module.sr_tableau.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}
