variable "password_policy_name" {
  description = "value of the password_policy_name"
  type        = string
}

variable "databse" {
  description = "The database in which to create the password policy"
  type        = string
}

variable "schema" {
  description = "The schema in which to create the password policy"
  type        = string
}

variable "comment" {
  description = "Specifies a comment for the password policy"
  type        = string
  default     = null
}

variable "max_age_days" {
  description = "value of the max_age_days"
  type        = number
  default     = 0
}

variable "min_length" {
  description = "Specifies the minimum length of the password"
  type        = number
  default     = 14
}
