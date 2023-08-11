variable "users" {
  type        = list(any)
  description = "user リスト"
}

variable "databases" {
  type        = list(any)
  description = "database リスト"
}

variable "schemas" {
  type        = list(any)
  description = "schema リスト"
}

variable "warehouses" {
  type        = list(any)
  description = "ウェアハウス リスト"
}

variable "functional_roles" {
  type        = list(any)
  description = "Functional roleリスト。[ {name: <role_name>, comment: <comment>},... ]"
}

variable "access_roles" {
  type        = list(any)
  description = "Access roleリスト。[ {name: <role_name>, comment: <comment>},... ]"
}