variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = null
}

variable "comment" {
  description = "Write description for the database"
  type        = string
  default     = null
}

variable "data_retention_time_in_days" {
  description = "Time travelable period to be set for the entire database."
  type        = number
  default     = null
}

variable "manager_ar_to_fr_set" {
  description = "Set of functional role for grant manager access role"
  type        = set(string)
  default     = []
}

variable "transformer_ar_to_fr_set" {
  description = "Set of functional role for grant read/write access role"
  type        = set(string)
  default     = []
}

variable "sr_trocco_import_ar_to_fr_set" {
  description = "Set of functional role for grant read/write access role"
  type        = set(string)
  default     = []
}

variable "sr_trocco_transform_ar_to_fr_set" {
  description = "Set of functional role for grant read/write access role"
  type        = set(string)
  default     = []
}

variable "read_only_ar_to_fr_set" {
  description = "Set of functional role for grant read only access role"
  type        = set(string)
  default     = []
}
