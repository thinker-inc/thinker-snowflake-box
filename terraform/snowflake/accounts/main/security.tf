########################
# Network Rule
# Network Ruleは、ネットワークアクセスを制御するためのルールです。
########################
module "network_rule_thinker" {
  source = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.terraform
  }

  rule_name = "NETWORK_RULE_THINKER"
  databse   = module.security_db.name
  schema    = module.security_db_network_schema.name
  comment   = "株式会社シンカー グローバルIP"
  type      = "IPV4"
  mode      = "INGRESS"
  value_list = [
    "133.242.237.194"
  ]
}

########################
# Network Policy
########################
locals {
  attachment_users = ["THINKER_HUANG"]
}
module "network_policy_thinker" {
  source = "../../modules/network_policy"
  providers = {
    snowflake = snowflake.terraform
  }

  policy_name = "NETWORK_POLICY_THINKER"
  comment     = "株式会社シンカー ネットワークポリシー"

  allowed_network_rule_list = [
    module.network_rule_thinker.fully_qualified_name
  ]

  blocked_network_rule_list = []

  set_for_account = false
  users           = local.attachment_users

}
