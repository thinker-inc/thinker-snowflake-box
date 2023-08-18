variable "users" {
  type        = list(any)
  description = "user リスト"
}

variable "functional_roles" {
  type        = list(any)
  description = "Functional roleリスト"
}

variable "access_roles" {
  type        = list(any)
  description = "Access roleリスト"
}

variable "warehouses" {
  type        = list(any)
  description = "ウェアハウス リスト"
}

variable "databases" {
  type        = list(any)
  description = "database リスト"
}

variable "schemas" {
  type        = list(any)
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