########################
# Google Sheets Database
########################
module "google_sheets_db" {
  source = "../../modules/access_role_and_database"
  providers = {
    snowflake = snowflake.terraform
  }

  database_name               = "GOOGLE_SHEETS"
  comment                     = "Database to store Google Sheets data imported by TROCCO"
  data_retention_time_in_days = 1

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = []

  read_only_ar_to_fr_set = [
    module.sr_tableau_sheets.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_transform_ar_to_fr_set = []
}

########################
# RAW_DATA Schema
########################
module "google_sheets_raw_data_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "RAW_DATA"
  database_name               = module.google_sheets_db.name
  comment                     = "Schema to store raw data from Google Sheets via TROCCO"
  data_retention_time_in_days = 1

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = []

  read_only_ar_to_fr_set = [
    module.sr_tableau_sheets.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]

  sr_transform_ar_to_fr_set = []

  grant_feature_external_table   = false
  grant_feature_stored_procedure = false
}