variable "name" {
  description = "Name of the service user. Note that if you do not supply login_name this will be used as login_name."
  type        = string
  default     = null
}

variable "login_name" {
  description = "The name of service users use to log in. If not supplied, snowflake will use name instead."
  type        = string
  default     = null
}

variable "comment" {
  description = "Write description for the resource"
  type        = string
  default     = null
}

variable "disabled" {
  description = "If true, the target user will not be deleted but deactivated"
  type        = string
  default     = null
}

variable "display_name" {
  description = "Name displayed for the serivice user in the Snowflake web interface."
  type        = string
  default     = null
}

variable "default_warehouse" {
  description = "Specifies the namespace (database only or database and schema) that is active by default for the service user's session upon login."
  type        = string
  default     = null
}

variable "default_secondary_roles_option" {
  description = "Specifies the set of secondary roles that are active for the service user's session upon login. Currently only [ALL] value is supported"
  type        = string
  default     = null
}

variable "default_role" {
  description = "Specifies the role that is active by default for the service user's session upon login."
  type        = string
  default     = "PUBLIC"
}

variable "rsa_public_key" {
  description = "Specifies the service user's RSA public key; used for key-pair authentication. Must be on 1 line without header and trailer."
  type        = string
  default     = null
}

variable "rsa_public_key_2" {
  description = "Specifies the service user's second RSA public key; used to rotate the public and private keys for key-pair authentication based on an expiration schedule set by your organization. Must be on 1 line without header and trailer."
  type        = string
  default     = null
}

