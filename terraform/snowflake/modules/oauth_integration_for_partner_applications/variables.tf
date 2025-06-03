variable "name" {
  description = "The name of the oauth integration for partner applications"
  type        = string
}

variable "oauth_client" {
  description = "The oauth client to use for the oauth integration for partner applications"
  type        = string
}

variable "enabled" {
  description = "Whether the oauth integration for partner applications is enabled"
  type        = bool
  default     = true
}

variable "oauth_issue_refresh_tokens" {
  description = "Whether the oauth integration for partner applications issues refresh tokens"
  type        = bool
  default     = true
}

variable "oauth_refresh_token_validity" {
  description = "The validity of the oauth refresh token"
  type        = number
  default     = 432000 # 5日
}

variable "oauth_use_secondary_roles" {
  description = "The secondary roles to use for the oauth integration for partner applications"
  type        = string
  default     = "NONE"
}

variable "blocked_roles_list" {
  description = "The roles to block for the oauth integration for partner applications"
  type        = list(string)
  default     = []
}

variable "comment" {
  description = "The comment for the oauth integration for partner applications"
  type        = string
  default     = null
}
