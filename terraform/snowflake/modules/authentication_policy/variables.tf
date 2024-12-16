variable "database" {
  description = "The name of the database to create the authentication policy in."
  type        = string
}

variable "schema" {
  description = "The name of the schema to create the authentication policy in."
  type        = string
}

variable "name" {
  description = "Name of the service user. Note that if you do not supply login_name this will be used as login_name."
  type        = string
}

# ALL, SAML, PASSWORD, OAUTH, KEYPAIR
variable "authentication_methods" {
  description = "List of authentication methods."
  type        = list(string)
  default     = ["ALL"]
}

# ALL, SAML, PASSWORD
variable "mfa_authentication_methods" {
  description = "List of MFA authentication methods."
  type        = list(string)
  default     = null
}

# OPTIONAL, REQUIRED
variable "mfa_enrollment" {
  description = "MFA enrollment setting."
  type        = string
  default     = "OPTIONAL"
}

# ALL, SNOWFLAKE_UI, DRIVERS, SNOWSQL
variable "client_types" {
  description = "List of client types."
  type        = list(string)
  default     = ["ALL"]
}

variable "security_integrations" {
  description = "List of security integrations."
  type        = list(string)
  default     = ["ALL"]
}

variable "comment" {
  description = "Comment for the authentication policy."
  type        = string
  default     = "My authentication policy."
}

variable "is_account" {
  type    = bool
  default = false # trueにすればリソースが作成され、falseなら作成されない
}

variable "users" {
  description = "List of users to attach the authentication policy to."
  type        = set(string)
  default     = []

}
