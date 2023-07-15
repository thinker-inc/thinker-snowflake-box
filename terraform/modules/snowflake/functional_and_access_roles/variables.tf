variable "functional_roles" {
  type        = list(any)
  description = "Functional roleリスト。[ {name: <role_name>, comment: <comment>},... ]"
}

variable "access_roles" {
  type        = list(any)
  description = "Access roleリスト。[ {name: <role_name>, comment: <comment>},... ]"
}

variable "users" {
  type        = list(any)
  description = "user roleリスト"
}
