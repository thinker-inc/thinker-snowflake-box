module "module" {
  source                                 = "../modules"
  warehouses                             = local.warehouses
  databases                              = local.databases
  schemas                                = local.schemas
  functional_roles                       = local.functional_roles
  access_roles                           = local.access_roles
  grant_access_roles_to_functional_roles = local.grant_access_roles_to_functional_roles
  grant_functional_roles_to_users        = local.grant_functional_roles_to_users
  warehouse_privileges                   = local.warehouse_privileges
  database_privileges                    = local.database_privileges
  schema_privileges                      = local.schema_privileges
  future_schemas_privieges               = local.future_schemas_privieges
  view_privileges                        = local.view_privileges
  standard_monitors                      = local.standard_monitors
}
