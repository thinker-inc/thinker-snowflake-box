# Functional roleとAccess roleを作成
module "create_account_objects" {
  source = "../modules/snowflake/create_account_objects"
  providers = {
    snowflake = snowflake.terraform
  }

  users                                  = local.users
  databases                              = local.databases
  schemas                                = local.schemas
  warehouses                             = local.warehouses
  functional_roles                       = local.functional_roles

  access_roles                           = local.access_roles

}

module "grant_roles" {
  source = "../modules/snowflake/grant_roles"
  providers = {
    snowflake = snowflake.terraform
  }

  grant_functional_roles_to_user         = local.grant_functional_roles_to_user

  grant_access_roles_to_functional_roles = local.grant_access_role_to_functional_role

  depends_on = [module.create_account_objects]
}

module "privileges_to_role" {
  source = "../modules/snowflake/privileges_to_role"
  providers = {
    snowflake = snowflake.terraform
  }

  grant_on_object_to_access_role         = local.grant_on_object_to_access_role
  
  depends_on = [module.create_account_objects]
}