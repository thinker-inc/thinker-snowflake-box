variable "storage_integration_name" {
  description = "value of the storage integration name"
  type        = string
}

variable "comment" {
  description = "value of the storage integration comment"
  type        = string
  default     = null
}

variable "type" {
  description = "value of the storage integration type"
  type        = string
}

variable "enabled" {
  description = "value of the storage integration enabled"
  type        = bool
  default     = true
}

variable "storage_allowed_locations" {
  description = "value of the storage integration storage allowed locations"
  type        = list(string)
  default     = []
}

variable "storage_provider" {
  description = "value of the storage integration storage provider"
  type        = string
}

variable "storage_aws_role_arn" {
  description = "value of the storage integration storage aws role arn"
  type        = string
}

variable "storage_roles_ar_to_fr_set" {
  description = "Set of functional role for grant roles"
  type        = set(string)
  default     = []
}
