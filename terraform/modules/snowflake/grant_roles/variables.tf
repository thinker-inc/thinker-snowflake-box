variable "grant_access_roles_to_functional_roles" {
  type        = list(any)
  description = "Access role を付与する Functional role のリスト。[ {functional_roles: [<role_a>, <role_b>, ...], access_role: <role_name>},... ]"
}