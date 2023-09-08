# Functional roleとAccess roleを作成
module "create_structured" {
  source = "../modules/structured"

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
  storage_integrations                   = local.storage_integrations
  streams                                = local.streams
  external_tables                        = local.external_tables
  tasks                                  = local.tasks
  grant_functional_roles_to_user         = local.grant_functional_roles_to_user
  grant_access_roles_to_functional_roles = local.grant_access_role_to_functional_role
  grant_on_object_to_access_role         = local.grant_on_object_to_access_role
}