variable "rule_name" {
  description = "value of the network rule"
  type        = string
}

variable "databse" {
  description = "The database in which to create the network rule"
  type        = string
}

variable "schema" {
  description = "The schema in which to create the network rule"
  type        = string
}

variable "comment" {
  description = "Specifies a comment for the network rule"
  type        = string
  default     = null
}

# IPV4, AWSVPCEID, AZURELINKID and HOST_PORT
variable "type" {
  description = "pecifies the type of network identifiers being allowed or blocked. A network rule can have only one type"
  type        = string
}

variable "mode" {
  description = "Specifies what is restricted by the network rule. Valid values are INGRESS, INTERNAL_STAGE and EGRESS"
  type        = string
}

variable "value_list" {
  description = " Specifies the network identifiers that will be allowed or blocked. Valid values in the list are determined by the type of network rule"
  type        = set(string)
  default     = []
}
