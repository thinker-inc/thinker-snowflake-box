# Functional roleとAccess roleを作成
module "functional_and_access_roles" {
  source = "../../modules/snowflake/functional_and_access_roles"
  providers = {
    snowflake = snowflake.tf_useradmin
  }

  functional_roles                       = local.functional_roles
  access_roles                           = local.access_roles
  users                                  = local.users
}

module "grant_roles" {
  source = "../../modules/snowflake/grant_roles"
  providers = {
    snowflake = snowflake.tf_securityadmin
  }

  grant_access_roles_to_functional_roles = local.grant_access_role_to_functional_role
}

module "warehouses" {
  source = "../../modules/snowflake/warehouses"
  providers = {
    snowflake = snowflake.tf_sysadmin
  }

  warehouses = local.warehouses
}