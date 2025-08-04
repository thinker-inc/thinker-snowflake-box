########################
# SERVICE USER
########################

module "trocco_user" {
  source = "../../modules/service_user"
  providers = {
    snowflake = snowflake.security_admin
  }

  name              = "TROCCO_USER"
  comment           = "trocco service user was created by terraform"
  default_role      = "SR_TROCCO_IMPORT"
  default_warehouse = "SR_TROCCO_IMPORT_WH"
}

########################
# Functional Role
########################
module "fr_manager" {
  source = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name      = "FR_MANAGER"
  grant_user_set = local.manager
  comment        = "Functional Role for Admin in Project all"
}

module "fr_data_engineer" {
  source = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name      = "FR_DATA_ENGINEER"
  grant_user_set = local.manager
  comment        = "Functional Role for Data Engineer in Project all"
}

module "fr_scientist" {
  source = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name      = "FR_SCIENTIST"
  grant_user_set = local.manager
  comment        = "Functional Role for data scientist in Project {}"
}

module "fr_analyst" {
  source = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name      = "FR_ANALYST"
  grant_user_set = local.manager
  comment        = "Functional Role for analysis in Project {}"
}

module "sr_tableau" {
  source = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name      = "SR_TABLEAU"
  grant_user_set = local.manager
  comment        = "Functional Role for business intelligence in Project {}"
}

module "sr_trocco_import" {
  depends_on = [module.trocco_user]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "SR_TROCCO_IMPORT"

  grant_user_set = concat(local.manager, ["TROCCO_USER"])
  comment        = "Functional Role for trocco import in Project {}"
}

module "sr_trocco_transform" {
  depends_on = [module.trocco_user]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name      = "SR_TROCCO_TRANSFORM"
  grant_user_set = concat(local.manager, ["TROCCO_USER"])
  comment        = "Functional Role for trocco transform in Project {}"
}

module "sr_trocco_spreadsheet" {
  depends_on = [module.trocco_user]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name      = "SR_TROCCO_SPREADSHEET"
  grant_user_set = concat(local.manager, ["TROCCO_USER"])
  comment        = "Functional Role for trocco spreadsheet in Project {}"
}

########################
# Warehouse
########################
module "manager_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }

  warehouse_name = "MANAGER_WH"
  warehouse_size = "XSMALL"
  comment        = "Warehouse for manager of {} projects"

  grant_usage_ar_to_fr_set = [
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

module "transformer_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }

  warehouse_name = "TRANSFORMER_WH"
  warehouse_size = "XSMALL"
  comment        = "Warehouse for Transformer of {} projects"

  grant_usage_ar_to_fr_set = [
    module.fr_data_engineer.name,
    module.fr_scientist.name
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

module "read_only_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }

  warehouse_name = "READ_ONLY_WH"
  warehouse_size = "XSMALL"
  comment        = "Warehouse for Read Only of {} projects"

  grant_usage_ar_to_fr_set = [
    module.fr_analyst.name,
    module.sr_tableau.name
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

module "sr_trocco_import_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }

  warehouse_name = "SR_TROCCO_IMPORT_WH"
  warehouse_size = "XSMALL"
  comment        = "Warehouse for TROCCO IMPORT of {} projects"

  grant_usage_ar_to_fr_set = [
    module.sr_trocco_import.name
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

module "sr_trocco_transform_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }

  warehouse_name = "SR_TROCCO_TRANSFORM_WH"
  warehouse_size = "XSMALL"
  comment        = "Warehouse for TROCCO TRANSFORM of {} projects"

  grant_usage_ar_to_fr_set = [
    module.sr_trocco_transform.name
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

module "sr_trocco_spreadsheet_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }

  warehouse_name = "SR_TROCCO_SPREADSHEET_WH"
  warehouse_size = "XSMALL"
  comment        = "Warehouse for TROCCO SPREADSHEET of {} projects"

  grant_usage_ar_to_fr_set = [
    module.sr_trocco_spreadsheet.name
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

module "security_manager_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }

  warehouse_name = "SECURITY_MANAGER_WH"
  warehouse_size = "XSMALL"
  comment        = "Warehouse for Security Manager"

  grant_usage_ar_to_fr_set = [
    local.security_role_name
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

module "sr_tableau_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }
  warehouse_name    = "SR_TABLEAU_WH"
  warehouse_size    = "XSMALL"
  comment           = "Warehouse for TABLEAU"
  max_cluster_count = 1

  grant_usage_ar_to_fr_set = [
    module.sr_tableau.name
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}
