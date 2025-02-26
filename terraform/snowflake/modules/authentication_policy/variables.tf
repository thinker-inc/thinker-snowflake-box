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

variable "authentication_methods" {
  description = "List of authentication methods. { ALL | SAML | PASSWORD | OAUTH | KEYPAIR }"
  type        = list(string)
  default     = ["ALL"]
}

variable "mfa_authentication_methods" {
  description = "List of MFA authentication methods. { ALL | SAML | PASSWORD }"
  type        = list(string)
  default     = null
}

variable "mfa_enrollment" {
  description = "MFA enrollment setting. { OPTIONAL | REQUIRED }"
  type        = string
  default     = "OPTIONAL"
}

variable "client_types" {
  description = "List of client types. { ALL | SNOWFLAKE_UI | DRIVERS | SNOWSQL }"
  type        = list(string)
  default     = ["ALL"]
}

variable "security_integrations" {
  description = "List of security integrations. { ALL | AWS_IAM | API_AUTHENTICATION | EXTERNAL_OAUTH | OAUTH | SAML2 | SCIM }"
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
