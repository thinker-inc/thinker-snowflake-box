# variable "warehouse_privileges" {
#   type        = list(any)
# }

# variable "database_privileges" {
#   type        = list(any)
# }

# variable "schema_privileges" {
#   type        = list(any)
# }

# variable "fileformat_privileges" {
#   type        = list(any)
# }

# variable "pipe_privileges" {
#   type        = list(any)
# }

# variable "stage_privileges" {
#   type        = list(any)
# }

# variable "external_table_privileges" {
#   type        = list(any)
# }

# variable "task_privileges" {
#   type        = list(any)
# }

# variable "future_privileges" {
#   type        = list(any)
# }

variable "grant_on_object_to_access_role" {
  # type        = list(any)
  type = list(object({
    name      = string
    role      = string
    class     = string
    type      = string
    parameter = object({
      privileges    = list(string)
      database_name = optional(string)
      schema_name   = optional(string)
      table_name    = optional(string)
      object_name   = optional(string)
    })
  }))
  description = "grant on ○○ を付与する Access role のリスト。[ {name: <name>, roles: [<role_name>], type: SCHEMA/FUTURE_TABLE/WAREHOUSE/etc., parameter: <parameter>},... ]"
}