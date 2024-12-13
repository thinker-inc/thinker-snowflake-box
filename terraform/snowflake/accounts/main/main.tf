########################
# USER
########################
# ./definitions/users.tf
module "users" {
  source = "../../modules/user"
  providers = {
    snowflake = snowflake.security_admin
  }

  for_each = {
    for key, user in local.users : user.name => user
  }

  name     = each.value.name
  comment  = each.value.comment
  password = local.initial_user_password
}

module "etl_tool_user" {
  source = "../../modules/service_user"
  providers = {
    snowflake = snowflake.security_admin
  }

  name    = "ETL_USER"
  comment = "ETL tool service user was created by terraform"
}

module "bi_tool_user" {
  source = "../../modules/service_user"
  providers = {
    snowflake = snowflake.security_admin
  }

  name    = "BI_USER"
  comment = "BI tool service user was created by terraform"
}

########################
# Functional Role
########################
module "fr_manager" {
  depends_on = [module.users]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "FR_MANAGER"
  grant_user_set = [
    "RYOTA_HASEGAWA",
    "HUNAG"
  ]
  comment = "Functional Role for Admin in Project all"
}

module "fr_data_engineer" {
  depends_on = [module.users]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "FR_DATA_ENGINEER"
  grant_user_set = [
    "RYOTA_HASEGAWA",
    "ENGINEER_HASEGAWA",
    "HUNAG"
  ]
  comment = "Functional Role for Data Engineer in Project all"
}

module "fr_scientist" {
  depends_on = [module.users]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "FR_SCIENTIST"
  grant_user_set = [
    "RYOTA_HASEGAWA",
    "SCIENTIST_HASEGAWA",
    "HUNAG"
  ]
  comment = "Functional Role for data scientist in Project {}"
}

module "fr_analyst" {
  depends_on = [module.users]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "FR_ANALYST"
  grant_user_set = [
    "RYOTA_HASEGAWA",
    "ANALYST_HASEGAWA",
    "HUNAG"
  ]
  comment = "Functional Role for analysis in Project {}"
}

module "fr_bi_tool" {
  depends_on = [module.users, module.bi_tool_user]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "FR_BI_TOOL"
  grant_user_set = [
    "RYOTA_HASEGAWA",
    module.bi_tool_user.name,
    "HUNAG"
  ]
  comment = "Functional Role for business intelligence in Project {}"
}

module "fr_etl_tool_import" {
  depends_on = [module.users, module.etl_tool_user]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "FR_ETL_TOOL_IMPORT"
  grant_user_set = [
    "RYOTA_HASEGAWA",
    module.etl_tool_user.name,
    "HUNAG"
  ]
  comment = "Functional Role for etl tools import in Project {}"
}

module "fr_etl_tool_transform" {
  depends_on = [module.users, module.etl_tool_user]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "FR_ETL_TRANSFORM"
  grant_user_set = [
    "RYOTA_HASEGAWA",
    module.etl_tool_user.name,
    "HUNAG"
  ]
  comment = "Functional Role for etl tools transform in Project {}"
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
    module.fr_analyst.name
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

module "etl_tool_import_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }

  warehouse_name = "ETL_IMPORT_WH"
  warehouse_size = "XSMALL"
  comment        = "Warehouse for ETL IMPORT of {} projects"

  grant_usage_ar_to_fr_set = [
    module.fr_etl_tool_import.name
  ]
  grant_admin_ar_to_fr_set = [
    module.fr_manager.name
  ]
}

module "etl_tool_transform_wh" {
  source = "../../modules/access_role_and_warehouse"
  providers = {
    snowflake = snowflake.terraform
  }

  warehouse_name = "ETL_TRANSFORM_WH"
  warehouse_size = "XSMALL"
  comment        = "Warehouse for ETL TRANSFORM of {} projects"

  grant_usage_ar_to_fr_set = [
    module.fr_etl_tool_transform.name
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
