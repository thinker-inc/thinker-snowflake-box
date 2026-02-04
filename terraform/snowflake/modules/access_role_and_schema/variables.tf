variable "schema_name" {
  description = "Name of the schema"
  type        = string
  default     = null
}

variable "database_name" {
  description = "Name of the database to which the Schema belongs"
  type        = string
  default     = null
}

variable "comment" {
  description = "Write description for the schema"
  type        = string
  default     = null
}

variable "data_retention_time_in_days" {
  description = "Time travelable period to be set for the entire schema."
  type        = number
  default     = null
}

variable "with_managed_access" {
  description = "Specifies a managed schema."
  type        = bool
  default     = false
}

variable "is_transient" {
  description = "Specifies a schema as transient."
  type        = bool
  default     = false
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

variable "sr_import_ar_to_fr_set" {
  description = "Set of functional role for grant read/write access role"
  type        = set(string)
  default     = []
}

variable "sr_transform_ar_to_fr_set" {
  description = "Set of functional role for grant read/write access role"
  type        = set(string)
  default     = []
}

variable "read_only_ar_to_fr_set" {
  description = "Set of functional role for grant read only access role"
  type        = set(string)
  default     = []
}

variable "grant_feature_external_table" {
  type    = bool
  default = false # trueにすればリソースが作成され、falseなら作成されない
}

variable "grant_feature_stored_procedure" {
  type    = bool
  default = false # trueにすればリソースが作成され、falseなら作成されない

}

variable "grant_feature_function_usage" {
  description = "Feature flag. If true, grant USAGE on ALL/FUTURE FUNCTIONS in this schema to access roles (read_only and sr_import). Default is true (broad allow); set false to disable per schema."
  type        = bool
  default     = true
}
