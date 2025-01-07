########################
# Database
########################
module "workspace_db" {
  source = "../../modules/access_role_and_database"
  providers = {
    snowflake = snowflake.terraform
  }

  database_name               = "WORKSPACE"
  comment                     = "一時保管用オブジェクト"
  data_retention_time_in_days = 1

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name,
  ]

  read_only_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name,
    module.fr_analyst.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}

########################
# Schema
########################
module "workspace_db_service_a_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "SPOT"
  database_name               = module.workspace_db.name
  comment                     = "スポット用"
  data_retention_time_in_days = 1

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]

  transformer_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name,
    module.fr_analyst.name
  ]

  read_only_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name,
    module.fr_analyst.name
  ]

  sr_import_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
}
