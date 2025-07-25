########################
# SPREADSHEET_DATA Database
########################
module "spreadsheet_db" {
  source = "../../modules/access_role_and_database"
  providers = {
    snowflake = snowflake.terraform
  }

  database_name               = "SPREADSHEET_DATA"
  comment                     = "Database to store and process Google Spreadsheet data from TROCCO"
  data_retention_time_in_days = 1

  sr_import_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
}

########################
# RAW Schema - 生データ（TROCCOから直接取り込み）
########################
module "spreadsheet_db_raw_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "RAW"
  database_name               = module.spreadsheet_db.name
  comment                     = "Schema to store raw Google Spreadsheet data from TROCCO"
  data_retention_time_in_days = 1

  sr_import_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
}

########################
# CLEANED Schema - クレンジング済みデータ
########################
module "spreadsheet_db_cleaned_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "CLEANED"
  database_name               = module.spreadsheet_db.name
  comment                     = "Schema to store cleaned Google Spreadsheet data"
  data_retention_time_in_days = 1

  sr_import_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
}

########################
# TABLEAU_BI Schema - Tableau BI用データ
########################
module "spreadsheet_db_tableau_bi_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "TABLEAU_BI"
  database_name               = module.spreadsheet_db.name
  comment                     = "Schema to store data for Tableau BI from Google Spreadsheets"
  data_retention_time_in_days = 1

  sr_import_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
}
