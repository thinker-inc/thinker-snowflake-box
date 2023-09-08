variable "grant_functional_roles_to_user" {
  type        = list(any)
  description = "Functional role を付与するユーザーのリスト。[ {users: [<user_1>, <user_2, ...], role_name: <role_name>},... ]"
}

variable "grant_access_roles_to_functional_roles" {
  type        = list(any)
  description = "Access role を付与する Functional role のリスト。[ {functional_roles: [<role_a>, <role_b>, ...], access_role: <role_name>},... ]"
}