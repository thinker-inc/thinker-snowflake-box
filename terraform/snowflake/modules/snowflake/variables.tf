## 必ず実運用時はanyはやめましょう。明示的にしてね
variable "users" {
  type = list(object({
    name                 = string
    login_name           = string
    comment              = string
  }))
  description = "user リスト"
}

variable "functional_roles" {
  type = list(object({
    name    = string
    comment = string
  }))
  description = "Functional roleリスト"
}

variable "access_roles" {
  type = list(object({
    name    = string
    comment = string
  }))
  description = "Access roleリスト"
}

variable "warehouses" {
  type = list(object({
    name              = string
    comment           = string
    warehouse_size    = string
    min_cluster_count = number
    max_cluster_count = number
    auto_suspend      = number
  }))
  description = "ウェアハウス リスト"
}

variable "databases" {
  type        = list(object({
    name                        = string
    comment                     = string
    data_retention_time_in_days = number
  }))
  description = "database リスト"
}

variable "schemas" {
  type = list(object({
    name     = string
    database = string
    schema = string
    comment  = string
  }))
  description = "schema リスト"
}

variable "fileformats" {
  type        = list(any)
  description = "file format リスト"
}

variable "pipes" {
  type        = list(any)
  description = "pipes リスト"
}

variable "policies" {
  type        = list(any)
  description = "policies リスト"
}

variable "tags" {
  type        = list(any)
  description = "tags リスト"
}

variable "stages" {
  type        = list(any)
  description = "stages リスト"
}

variable "storage_integrations" {
  type        = list(any)
  description = "stages リスト"
}

variable "streams" {
  type        = list(any)
  description = "streams リスト"
}

variable "external_tables" {
  type        = list(any)
  description = "external_tables リスト"
}

variable "tasks" {
  type        = list(any)
  description = "tasks リスト"
}

variable "grant_functional_roles_to_user" {
  type = list(object({
    users     = list(string)
    role_name = string
  }))
  description = "Functional role を付与するユーザーのリスト"
}

variable "grant_access_roles_to_functional_roles" {
  type = list(object({
    name = string
    functional_roles = list(string)
    access_role     = string
  }))
  description = "Access role を付与する Functional role のリスト"
}

variable "grant_on_object_to_access_role" {
  # type        = list(any)
  type = list(object({
    name      = string
    role      = string
    class     = string
    type      = optional(string)
    parameter = object({
      privileges        = list(string)
      privileges_level  = optional(string)
      database_name     = optional(string)
      schema_name       = optional(string)
      table_name        = optional(string)
      object_name       = optional(string)
    })
  }))
  description = "grant on object を付与する Access role のリスト"
}