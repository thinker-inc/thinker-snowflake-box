locals {
  ##################################
  ### create_objects
  ##################################

  # Warehouses
  warehouses_yml = yamldecode(file("${path.root}/yaml/prd/create_objects/warehouses.yml"))
  warehouses     = local.warehouses_yml["warehouses"] != null ? local.warehouses_yml["warehouses"] : []

  # Databases and Schemas
  database_related_yml = yamldecode(file("${path.root}/yaml/prd/create_objects/database_related.yml"))
  databases            = local.database_related_yml["databases"] != null ? local.database_related_yml["databases"] : []

  schemas = flatten([
    for _database in local.databases : [
      for _schema in _database.schemas != null ? _database.schemas : [] : {
        index_name = "${_database.name}_${_schema.name}"
        name       = _schema.name
        database   = _database.name
        comment    = _schema.comment
      }
    ]
  ])

  # Functional Roles
  functional_roles_yml = yamldecode(file("${path.root}/yaml/prd/create_objects/roles_functional.yml"))
  functional_roles     = local.functional_roles_yml["functional_roles"] != null ? local.functional_roles_yml["functional_roles"] : []

  # Access Roles
  _databases = [
    #for f in fileset("", format("./environment/%s/*.yaml", terraform.workspace)):
    for f in fileset("", "${path.root}/yaml/prd/role_to_objects/*.yml") :
    yamldecode(file(f))["access_roles"]
  ]

  _access_roles = flatten([
    for v in local._databases : [
      for _v in v : _v
    ]
  ])

  access_roles_wh_yml = yamldecode(file("${path.root}/yaml/prd/create_objects/roles_access_wh.yml"))
  _access_roles_wh    = local.access_roles_wh_yml["access_roles"] != null ? local.access_roles_wh_yml["access_roles"] : []
  access_roles_wh = [
    for _warehouse in local._access_roles_wh != null ? local._access_roles_wh : [] : {
      name    = upper("${_warehouse.name}")
      comment = _warehouse.comment != null ? _warehouse.comment : "create access role for ${_warehouse.name} warehouse"
      functional_roles : _warehouse.functional_roles != null ? _warehouse.functional_roles : []
    }
  ]

  access_roles = concat(local._access_roles, local.access_roles_wh)

  ##################################
  ### grant_roles
  ##################################
  # Access roles to functional roles
  grant_access_roles_to_functional_roles = flatten([
    for _role in local._access_roles != null ? local._access_roles : [] : [
      for _function_role in _role.functional_roles != null ? _role.functional_roles : [] : {
        index            = upper("${_role.name}_TO_${_function_role}")
        role_name        = _role.name
        parent_role_name = _function_role
      }
    ]
  ])

  grant_access_wh_roles_to_functional_roles = flatten([
    for _role in local.access_roles_wh != null ? local.access_roles_wh : [] : [
      for _function_role in _role.functional_roles != null ? _role.functional_roles : [] : {
        index            = upper("${_role.name}_TO_${_function_role}")
        role_name        = _role.name
        parent_role_name = _function_role
      }
    ]
  ])

  # functional roles to users
  _grant_functional_roles_to_users = [
    for _role in local.functional_roles != null ? local.functional_roles : [] : {
      role_name = _role.name
      users     = _role.users != null ? _role.users : []
    }
  ]

  grant_functional_roles_to_users = flatten([
    for _role in local.functional_roles != null ? local.functional_roles : [] : [
      for _user in _role.users != null ? _role.users : [] : {
        index     = upper("${_role.name}_TO_${_user}")
        role_name = _role.name
        user_name = _user
      }
    ]
  ])

  ##################################
  ### privileges_to_roles
  ##################################
  # warehouse privileges
  # warehouse_privileges = flatten([
  #   for _warehouse_role in local._access_roles_wh != null ? local._access_roles_wh : [] : [
  #     for _warehouse in _warehouse_role.warehouses != null ? _warehouse_role.warehouses : [] : [
  #       for _role_name in _warehouse_role.functional_roles != null ? _warehouse_role.functional_roles : [] : {
  #         index      = upper("${_warehouse_role.name}__${_warehouse}__${_role_name}")
  #         role_name  = _role_name
  #         type       = "WAREHOUSE"
  #         warehouse  = _warehouse
  #         privileges = ["USAGE", "MONITOR", "OPERATE"]
  #       }
  #     ]
  # ]])

  warehouse_privileges = flatten([
    for _warehouse_role in local._access_roles_wh != null ? local._access_roles_wh : [] : [
      for _warehouse in _warehouse_role.warehouses != null ? _warehouse_role.warehouses : [] : {
        index      = upper("${_warehouse_role.name}__TO__${_warehouse}")
        role_name  = _warehouse_role.name
        type       = "WAREHOUSE"
        warehouse  = _warehouse
        privileges = ["USAGE", "MONITOR", "OPERATE"]
      }
  ]])


  # database privileges
  database_privileges = flatten([
    for _database_grant_role in local._access_roles != null ? local._access_roles : [] : [
      for _grant_account_role in _database_grant_role.grant_account_roles != null ? _database_grant_role.grant_account_roles : [] : {
        index      = "${_database_grant_role.name}_${_grant_account_role.database}"
        role_name  = _database_grant_role.name
        type       = "DATABASE"
        database   = _grant_account_role.database
        privileges = ["USAGE"]
      }
    ]
  ])

  # schema privileges
  schema_privileges = flatten([
    for _database_grant_role in local._access_roles != null ? local._access_roles : [] : [
      for _grant_account_role in _database_grant_role.grant_account_roles != null ? _database_grant_role.grant_account_roles : [] : [
        for _schema in _grant_account_role.schemas != null ? _grant_account_role.schemas : [] : {
          index            = "${_database_grant_role.name}_${_schema.name}"
          role_name        = _database_grant_role.name
          schema_name      = _schema.name
          database         = _grant_account_role.database
          type             = "SCHEMA"
          privileges       = _schema.privileges != null ? _schema.privileges : []
          table_privileges = _schema.table_privileges != null ? _schema.table_privileges : []
        }
      ]
    ]
  ])

  # future schema privileges
  future_schemas_privieges = flatten([
    for _database_grant_role in local._access_roles != null ? local._access_roles : [] : [
      for _grant_account_role in _database_grant_role.grant_account_roles != null ? _database_grant_role.grant_account_roles : [] : {
        index                     = "${_database_grant_role.name}"
        role_name                 = _database_grant_role.name
        database                  = _grant_account_role.database
        type                      = "SCHEMA"
        feature_schema_privileges = _grant_account_role.feature_schema_privileges != null ? _grant_account_role.feature_schema_privileges : []
      }
    ]
  ])

  # feature views privileges
  view_privileges = flatten([
    for _database_grant_role in local._access_roles != null ? local._access_roles : [] : [
      for _grant_account_role in _database_grant_role.grant_account_roles != null ? _database_grant_role.grant_account_roles : [] : [
        for _schema in _grant_account_role.schemas != null ? _grant_account_role.schemas : [] : {
          index           = "${_database_grant_role.name}_${_schema.name}"
          role_name       = _database_grant_role.name
          schema_name     = _schema.name
          database        = _grant_account_role.database
          type            = "VIEWS"
          view_privileges = _schema.view_privileges != null ? _schema.view_privileges : []
        }
      ]
    ]
  ])


  # ----- monitor -----
  standard_monitors_yml = yamldecode(file("${path.root}/yaml/prd/resource_monitors/standard.yml"))
  standard_monitors     = local.standard_monitors_yml["monitors"] != null ? local.standard_monitors_yml["monitors"] : []

}

# output "standard_monitors" {
#   value = local.standard_monitors
# }

# output "wh_access_roles" {
#   value = local.wh_access_roles
# }


# output "wh_access_roles" {
#   value = local.wh_access_roles
# }

# output "databases" {
#   value = local.databases
# }

# output "schemas" {
#   value = local.schemas
# }

# output "functional_roles" {
#   value = local.functional_roles
# }

# output "access_roles" {
#   value = local.access_roles
# }

# output "grant_access_roles_to_functional_roles" {
#   value = local.grant_access_roles_to_functional_roles
# }

# output "grant_functional_roles_to_users" {
#   value = local.grant_functional_roles_to_users
# }

# output "warehouse_privileges" {
#   value = local.warehouse_privileges
# }

# output "database_privileges" {
#   value = local.database_privileges
# }

# output "schema_privileges" {
#   value = local.schema_privileges
# }

# output "future_schemas_privieges" {
#   value = local.future_schemas_privieges
# }

# output "_databases" {
#   value = local._databases
# }

# output "_access_roles" {
#   value = local._access_roles
# }
