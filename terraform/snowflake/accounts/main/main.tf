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
  source = "../../modules/user"
  providers = {
    snowflake = snowflake.security_admin
  }

  name    = "ETL_USER"
  comment = "ETL tool user was created by terraform"
}

module "bi_tool_user" {
  source = "../../modules/user"
  providers = {
    snowflake = snowflake.security_admin
  }

  name    = "BI_USER"
  comment = "BI tool user was created by terraform"
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
    "RYOTA_HASEGAWA"
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
    module.bi_tool_user.name
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
    module.etl_tool_user.name
  ]
  comment = "Functional Role for etl tools import in Project {}"
}

module "fr_etl_tool_export" {
  depends_on = [module.users, module.etl_tool_user]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "FR_ETL_TOOL_EXPORT"
  grant_user_set = [
    "RYOTA_HASEGAWA",
    module.etl_tool_user.name
  ]
  comment = "Functional Role for etl tools export in Project {}"
}

module "fr_etl_tool_transition" {
  depends_on = [module.users, module.etl_tool_user]
  source     = "../../modules/functional_role"
  providers = {
    snowflake = snowflake.security_admin
  }

  role_name = "FR_ETL_TRANSITION"
  grant_user_set = [
    "RYOTA_HASEGAWA",
    module.etl_tool_user.name
  ]
  comment = "Functional Role for etl tools transition in Project {}"
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

########################
# Database
########################
# module "data_lake_db" {
#   source = "../../modules/access_role_and_database"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   database_name               = "DATA_LAKE"
#   comment                     = "Database to store loaded raw data"
#   data_retention_time_in_days = 1

#   admin_ar = [
#     module.fr_data_engineer.name
#   ]

#   transformer_ar = [
#     module.fr_data_analyst.name
#   ]

#   read_only_ar = [
#     module.fr_analyst.name
#   ]

#   etl_tool_ar = [
#     module.fr_etl_tool.name
#   ]
# }


# module "raw_data_db" {
#   source = "../../modules/access_role_and_database"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   database_name               = "RAW_DATA"
#   comment                     = "Database to store loaded raw data"
#   data_retention_time_in_days = 3
#   grant_readwrite_ar_to_fr_set = [
#     module.aaa_developer_fr.name,
#     module.bbb_developer_fr.name
#   ]
# }

# # module "staging_db" {
# #   source = "../../modules/access_role_and_database"
# #   providers = {
# #     snowflake = snowflake.terraform
# #   }

# #   database_name               = "STAGING"
# #   comment                     = "Database to store data with minimal transformation from raw data"
# #   data_retention_time_in_days = 1
# #   grant_readwrite_ar_to_fr_set = [
# #     module.aaa_developer_fr.name,
# #     module.bbb_developer_fr.name
# #   ]
# # }

# module "dwh_db" {
#   source = "../../modules/access_role_and_database"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   database_name               = "DWH"
#   comment                     = "Database to store data on which various modeling has been done"
#   data_retention_time_in_days = 1
#   grant_readonly_ar_to_fr_set = [
#     module.aaa_analyst_fr.name,
#     module.bbb_analyst_fr.name
#   ]
#   grant_readwrite_ar_to_fr_set = [
#     module.aaa_developer_fr.name,
#     module.bbb_developer_fr.name
#   ]
# }

# module "mart_db" {
#   source = "../../modules/access_role_and_database"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   database_name               = "MART"
#   comment                     = "Database that stores data used for reporting and linkage to another tool"
#   data_retention_time_in_days = 1
#   grant_readonly_ar_to_fr_set = [
#     module.aaa_analyst_fr.name,
#     module.bbb_analyst_fr.name
#   ]
#   grant_readwrite_ar_to_fr_set = [
#     module.aaa_developer_fr.name,
#     module.bbb_developer_fr.name
#   ]
# }

########################
# スキーマ
########################
# module "raw_data_db_aaa_schema" {
#   source = "../../modules/access_role_and_schema"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   schema_name         = "AAA"
#   database_name       = module.raw_data_db.name
#   comment             = "Schema to store loaded raw data of AAA"
#   data_retention_days = 3
#   grant_readwrite_ar_to_fr_set = [
#     module.aaa_developer_fr.name
#   ]
# }

# module "raw_data_db_bbb_schema" {
#   source = "../../modules/access_role_and_schema"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   schema_name         = "BBB"
#   database_name       = module.raw_data_db.name
#   comment             = "Schema to store loaded raw data of BBB"
#   data_retention_days = 3
#   grant_readwrite_ar_to_fr_set = [
#     module.bbb_developer_fr.name
#   ]
# }

# module "staging_db_aaa_schema" {
#   source = "../../modules/access_role_and_schema"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   schema_name         = "AAA"
#   database_name       = module.staging_db.name
#   comment             = "Schema to store data with minimal transformation from raw data of AAA"
#   data_retention_days = 1
#   grant_readwrite_ar_to_fr_set = [
#     module.aaa_developer_fr.name
#   ]
# }

# module "staging_db_bbb_schema" {
#   source = "../../modules/access_role_and_schema"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   schema_name         = "BBB"
#   database_name       = module.staging_db.name
#   comment             = "Schema to store data with minimal transformation from raw data of BBB"
#   data_retention_days = 1
#   grant_readwrite_ar_to_fr_set = [
#     module.bbb_developer_fr.name
#   ]
# }

# module "dwh_db_aaa_schema" {
#   source = "../../modules/access_role_and_schema"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   schema_name         = "AAA"
#   database_name       = module.dwh_db.name
#   comment             = "Schema to store data on which various modeling has been done for AAA"
#   data_retention_days = 1
#   grant_readonly_ar_to_fr_set = [
#     module.aaa_analyst_fr.name
#   ]
#   grant_readwrite_ar_to_fr_set = [
#     module.aaa_developer_fr.name
#   ]
# }

# module "dwh_db_bbb_schema" {
#   source = "../../modules/access_role_and_schema"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   schema_name         = "BBB"
#   database_name       = module.dwh_db.name
#   comment             = "Schema to store data on which various modeling has been done for BBB"
#   data_retention_days = 1
#   grant_readonly_ar_to_fr_set = [
#     module.bbb_analyst_fr.name
#   ]
#   grant_readwrite_ar_to_fr_set = [
#     module.bbb_developer_fr.name
#   ]
# }

# module "mart_db_aaa_schema" {
#   source = "../../modules/access_role_and_schema"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   schema_name         = "AAA"
#   database_name       = module.mart_db.name
#   comment             = "Schema that stores data used for reporting and linkage to another tool for AAA"
#   data_retention_days = 1
#   grant_readonly_ar_to_fr_set = [
#     module.aaa_analyst_fr.name
#   ]
#   grant_readwrite_ar_to_fr_set = [
#     module.aaa_developer_fr.name
#   ]
# }

# module "mart_db_bbb_schema" {
#   source = "../../modules/access_role_and_schema"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   schema_name         = "BBB"
#   database_name       = module.mart_db.name
#   comment             = "Schema that stores data used for reporting and linkage to another tool for BBB"
#   data_retention_days = 1
#   grant_readonly_ar_to_fr_set = [
#     module.bbb_analyst_fr.name
#   ]
#   grant_readwrite_ar_to_fr_set = [
#     module.bbb_developer_fr.name
#   ]
# }

# ########################
# # ウェアハウス
# ########################
# module "aaa_analyse_wh" {
#   source = "../../modules/access_role_and_warehouse"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   warehouse_name = "AAA_ANALYSE_WH"
#   warehouse_size = "XSMALL"
#   comment        = "Warehouse for analysis of AAA projects"

#   grant_usage_ar_to_fr_set = [
#     module.aaa_analyst_fr.name
#   ]
#   grant_admin_ar_to_fr_set = [
#     module.aaa_developer_fr.name
#   ]
# }

# module "bbb_analyse_wh" {
#   source = "../../modules/access_role_and_warehouse"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   warehouse_name = "BBB_ANALYSE_WH"
#   warehouse_size = "XSMALL"
#   comment        = "Warehouse for analysis of BBB projects"

#   grant_usage_ar_to_fr_set = [
#     module.bbb_analyst_fr.name
#   ]
#   grant_admin_ar_to_fr_set = [
#     module.bbb_developer_fr.name
#   ]
# }

# module "aaa_develop_wh" {
#   source = "../../modules/access_role_and_warehouse"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   warehouse_name = "AAA_DEVELOP_WH"
#   warehouse_size = "XSMALL"
#   comment        = "Warehouse for develop of AAA projects"

#   grant_admin_ar_to_fr_set = [
#     module.aaa_developer_fr.name
#   ]
# }

# module "bbb_develop_wh" {
#   source = "../../modules/access_role_and_warehouse"
#   providers = {
#     snowflake = snowflake.terraform
#   }

#   warehouse_name = "BBB_DEVELOP_WH"
#   warehouse_size = "XSMALL"
#   comment        = "Warehouse for develop of BBB projects"

#   grant_admin_ar_to_fr_set = [
#     module.bbb_developer_fr.name
#   ]
# }
