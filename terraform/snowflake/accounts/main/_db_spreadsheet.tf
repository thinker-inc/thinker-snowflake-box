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

  read_only_ar_to_fr_set = [
    module.sr_tableau.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
}

########################
# SOURCE Schema - 生データ（TROCCOから直接取り込み）
########################
module "spreadsheet_db_lake_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "LAKE"
  database_name               = module.spreadsheet_db.name
  comment                     = "Schema to store raw Google Spreadsheet data from TROCCO"
  data_retention_time_in_days = 1

  read_only_ar_to_fr_set = [
    module.sr_tableau.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
}

########################
# STAGING Schema - クレンジング済みデータ
########################
module "spreadsheet_db_staging_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "STAGING"
  database_name               = module.spreadsheet_db.name
  comment                     = "Schema to store cleaned Google Spreadsheet data"
  data_retention_time_in_days = 1

  read_only_ar_to_fr_set = [
    module.sr_tableau.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
}

########################
# DWH Schema - データウェアハウス
########################
module "spreadsheet_db_dwh_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "DWH"
  database_name               = module.spreadsheet_db.name
  comment                     = "Schema to store data warehouse tables from Google Spreadsheets"
  data_retention_time_in_days = 1

  read_only_ar_to_fr_set = [
    module.sr_tableau.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
}

########################
# MART Schema - 分析用データ
########################
module "spreadsheet_db_mart_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "MART"
  database_name               = module.spreadsheet_db.name
  comment                     = "Schema to store analysis-ready data from Google Spreadsheets"
  data_retention_time_in_days = 1

  read_only_ar_to_fr_set = [
    module.sr_tableau.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]

  sr_transform_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
}
