########################
# Database
########################
module "dwh_db" {
  source = "../../modules/access_role_and_database"
  providers = {
    snowflake = snowflake.terraform
  }

  database_name               = "DWH"
  comment                     = "Database to store data on which various modeling has been done"
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
    module.sr_tableau.name,
    module.sr_looker_studio.name
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
module "dwh_db_int_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "INT"
  database_name               = module.dwh_db.name
  comment                     = "Schema to store intermediate data for data modeling"
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
    module.sr_tableau.name,
    module.sr_looker_studio.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}

module "dwh_db_dim_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "DIM"
  database_name               = module.dwh_db.name
  comment                     = "Schema to store dimension tables for data modeling"
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
    module.sr_tableau.name,
    module.sr_looker_studio.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}

module "dwh_db_fct_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "FCT"
  database_name               = module.dwh_db.name
  comment                     = "Schema to store fact tables for data modeling"
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
    module.sr_tableau.name,
    module.sr_looker_studio.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}
