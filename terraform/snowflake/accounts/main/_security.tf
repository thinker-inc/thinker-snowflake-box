########################
# Database
########################
module "security_db" {
  source = "../../modules/access_role_and_database"
  providers = {
    snowflake = snowflake.terraform
  }

  database_name               = "SECURITY"
  comment                     = "セキュリティ管理用オブジェクト"
  data_retention_time_in_days = 30

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

########################
# Schema
########################
module "security_db_network_schema" {
  source = "../../modules/access_role_and_schema"
  providers = {
    snowflake = snowflake.terraform
  }

  schema_name                 = "NETWORK"
  database_name               = module.security_db.name
  comment                     = "セキュリティルール"
  data_retention_time_in_days = 30

  manager_ar_to_fr_set = [
    module.fr_manager.name
  ]
}
