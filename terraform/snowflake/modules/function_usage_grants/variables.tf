variable "account_role_names" {
  description = "Grant target account roles (e.g. SR_TROCCO_IMPORT)."
  type        = list(string)
}

variable "in_schemas" {
  description = "Target schemas in fully-qualified format (e.g. \\\"\\\"DWH\\\".\\\"INT\\\"\\\")."
  type        = list(string)
}

