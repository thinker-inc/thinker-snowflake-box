# Functional roleとAccess roleを作成
module "create_objects" {
  source = "../modules/snowflake/create_objects"
  providers = {
    snowflake = snowflake.terraform
  }

  users                                  = local.users
  functional_roles                       = local.functional_roles
  access_roles                           = local.access_roles
  warehouses                             = local.warehouses
  databases                              = local.databases
  schemas                                = local.schemas
  fileformats                            = local.fileformats
  pipes                                  = local.pipes
  policies                               = local.policies
  tags                                   = local.tags
  stages                                 = local.stages
  streams                                = local.streams
  external_tables                        = local.external_tables
  tasks                                  = local.tasks
}

module "grant_roles" {
  source = "../modules/snowflake/grant_roles"
  providers = {
    snowflake = snowflake.terraform
  }

  grant_functional_roles_to_user         = local.grant_functional_roles_to_user
  grant_access_roles_to_functional_roles = local.grant_access_role_to_functional_role

  depends_on = [module.create_objects]
}

module "privileges_to_role" {
  source = "../modules/snowflake/privileges_to_role"
  providers = {
    snowflake = snowflake.terraform
  }

  grant_on_object_to_access_role = local.grant_on_object_to_access_role
  # warehouse_privileges      = local.warehouse_privileges
  # database_privileges       = local.database_privileges
  # schema_privileges         = local.schema_privileges
  # fileformat_privileges     = local.fileformat_privileges
  # pipe_privileges           = local.pipe_privileges
  # stage_privileges          = local.stage_privileges
  # external_table_privileges = local.external_table_privileges
  # task_privileges           = local.task_privileges
  # future_privileges         = local.future_privileges

  depends_on = [module.create_objects]
}