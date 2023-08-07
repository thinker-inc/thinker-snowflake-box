# Functional roleとAccess roleを作成
module "functional_and_access_roles" {
  source = "../modules/snowflake/functional_and_access_roles"
  providers = {
    snowflake = snowflake.terraform
  }

  users                                  = local.users
  databases                              = local.databases
  schemas                                = local.schemas
  warehouses                             = local.warehouses
  functional_roles                       = local.functional_roles
  grant_functional_roles_to_user         = local.grant_functional_roles_to_user

  access_roles                           = local.access_roles
  grant_on_object_to_access_role         = local.grant_on_object_to_access_role

  grant_access_roles_to_functional_roles = local.grant_access_role_to_functional_role

}