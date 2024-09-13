variable "policy_name" {
  description = "value of the network policy"
  type        = string
}

variable "comment" {
  description = "Specifies a comment for the network policy"
  type        = string
  default     = null
}

variable "allowed_network_rule_list" {
  description = "Specifies a list of fully qualified network rules that contain the network identifiers that are allowed access to Snowflake."
  type        = set(string)
  default     = []
}

variable "blocked_network_rule_list" {
  description = "Specifies a list of fully qualified network rules that contain the network identifiers that are denied access to Snowflake."
  type        = set(string)
  default     = []
}

variable "set_for_account" {
  description = "Specifies whether the network policy should be applied globally to your Snowflake account"
  type        = bool
  default     = false
}

variable "users" {
  description = "value of the attached users"
  type        = set(string)
  default     = []
}
