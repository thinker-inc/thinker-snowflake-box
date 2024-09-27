# https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/network_rule
# snowflake_network_rule
resource "snowflake_network_policy" "this" {
  name                      = var.policy_name
  comment                   = var.comment
  allowed_network_rule_list = var.allowed_network_rule_list
  blocked_network_rule_list = var.blocked_network_rule_list
}

resource "snowflake_network_policy_attachment" "attach" {
  network_policy_name = snowflake_network_policy.this.name
  set_for_account     = var.set_for_account
  users               = var.users
}
