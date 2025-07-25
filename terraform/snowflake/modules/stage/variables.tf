variable "name" {
  description = "value of the stage name"
  type        = string
}

variable "url" {
  description = "value of the stage url"
  type        = string
}

variable "database" {
  description = "value of the stage database"
  type        = string
}

variable "schema" {
  description = "value of the stage schema"
  type        = string
}

variable "file_format" {
  description = "value of the stage file_format"
  type        = string
}

variable "stage_roles_ar_to_fr_set" {
  description = "value of the stage roles to grant privileges"
  type        = set(string)
  default     = []
}

variable "storage_integration" {
  description = "value of the stage storage_integration"
  type        = string
}

variable "comment" {
  description = "value of the stage comment"
  type        = string
  default     = null
}

variable "directory" {
  description = "value of the stage directory"
  type        = string
  default     = false
} 
