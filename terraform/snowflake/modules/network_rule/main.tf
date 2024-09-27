# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/network_rule
# snowflake_network_rule
resource "snowflake_network_rule" "this" {
  name       = var.rule_name
  database   = var.databse
  schema     = var.schema
  comment    = var.comment
  type       = var.type
  mode       = var.mode
  value_list = var.value_list
}
