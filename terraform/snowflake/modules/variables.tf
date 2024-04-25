variable "warehouses" {
  type = list(object({
    name              = string
    warehouse_size    = string
    auto_suspend      = number
    comment           = string
    max_cluster_count = number
    min_cluster_count = number
    warehouse_type    = string
  }))
  description = "Snowflake warehouses"
}

variable "databases" {
  type = list(object({
    name                        = string
    comment                     = string
    data_retention_time_in_days = number
  }))
  description = "Snowflake databases"
}

variable "schemas" {
  type = list(object({
    index_name = string
    name       = string
    database   = string
    comment    = string
  }))
  description = "Snowflake schemas"
}

variable "functional_roles" {
  type = list(object({
    name    = string
    comment = string
  }))
  description = "Snowflake functional roles"
}

variable "access_roles" {
  type = list(object({
    name    = string
    comment = string
  }))
  description = "Snowflake access roles"
}

variable "grant_access_wh_roles_to_functional_roles" {
  type = list(object({
    index            = string
    role_name        = string
    parent_role_name = string
  }))
  description = "Access role を付与する Functional role のリスト。[ {functional_roles: [<role_a>, <role_b>, ...], access_role: <role_name>},... ]"
}

variable "grant_access_roles_to_functional_roles" {
  type = list(object({
    index            = string
    role_name        = string
    parent_role_name = string
  }))
  description = "Access role を付与する Functional role のリスト。[ {functional_roles: [<role_a>, <role_b>, ...], access_role: <role_name>},... ]"
}


variable "grant_functional_roles_to_users" {
  type = list(object({
    index     = string
    role_name = string
    user_name = string
  }))
  description = "Functional role を付与するユーザーのリスト。[ {users: [<user_1>, <user_2, ...], role_name: <role_name>},... ]"
}

variable "warehouse_privileges" {
  type = list(object({
    index      = string
    role_name  = string
    type       = string
    warehouse  = string
    privileges = list(string)
  }))
  description = "grant on ○○ を付与する Access role のリスト。[ {name: <name>, roles: [<role_name>], type: WAREHOUSE, DATABASE parameter: <parameter>},... ]"
}

variable "database_privileges" {
  type = list(object({
    index      = string
    role_name  = string
    type       = string
    database   = string
    privileges = list(string)
  }))
  description = "grant on ○○ を付与する Access role のリスト。[ {name: <name>, roles: [<role_name>], type: WAREHOUSE, DATABASE parameter: <parameter>},... ]"
}

variable "schema_privileges" {
  type = list(object({
    index            = string
    role_name        = string
    type             = string
    schema_name      = string
    database         = string
    privileges       = list(string)
    table_privileges = list(string)
  }))
  description = "grant on ○○ を付与する Access role のリスト。[ {name: <name>, roles: [<role_name>], type: WAREHOUSE, DATABASE parameter: <parameter>},... ]"
}

variable "future_schemas_privileges" {
  type = list(object({
    index                     = string
    role_name                 = string
    type                      = string
    database                  = string
    feature_schema_privileges = list(string)
  }))
  description = "grant on ○○ を付与する Access role のリスト。[ {name: <name>, roles: [<role_name>], type: WAREHOUSE, DATABASE parameter: <parameter>},... ]"
}

variable "view_privileges" {
  type = list(object({
    index           = string
    role_name       = string
    type            = string
    database        = string
    schema_name     = string
    view_privileges = list(string)
  }))
  description = "grant on ○○ を付与する Access role のリスト。[ {name: <name>, roles: [<role_name>], type: WAREHOUSE, DATABASE parameter: <parameter>},... ]"
}

variable "standard_monitors" {
  type = list(object({
    name                      = string
    credit_quota              = number
    frequency                 = string
    start_timestamp           = string
    notify_triggers           = list(number)
    suspend_trigger           = number
    suspend_immediate_trigger = number
    notify_users              = list(string)
    set_for_account           = bool
    warehouses                = list(string)
  }))
  description = "Snowflake Resource Monitors with standard settings"
}
