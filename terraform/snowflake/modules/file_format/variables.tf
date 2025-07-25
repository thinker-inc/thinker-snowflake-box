variable "name" {
  description = "value of the file format name"
  type        = string
}

variable "database" {
  description = "value of the file format database"
  type        = string
}

variable "schema" {
  description = "value of the file format schema"
  type        = string
}

variable "format_type" {
  description = "value of the file format format_type { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM }"
  type        = string
}

variable "file_format_roles_ar_to_fr_set" {
  description = "Set of functional role for grant roles"
  type        = set(string)
  default     = []
}

variable "comment" {
  description = "value of the file format comment"
  type        = string
  default     = null
}

variable "field_delimiter" {
  description = "value of the file format field_delimiter"
  type        = string
  default     = null
}

variable "escape" {
  description = "value of the file format escape"
  type        = string
  default     = null
}

variable "encoding" {
  description = "value of the file format encoding"
  type        = string
  default     = null
}

variable "field_optionally_enclosed_by" {
  description = "value of the file format field_optionally enclosed by"
  type        = string
  default     = null
}

variable "parse_header" {
  description = "value of the file format parse header"
  type        = bool
  default     = null
}

variable "skip_header" {
  description = "value of the file format skip header"
  type        = number
  default     = null
}
