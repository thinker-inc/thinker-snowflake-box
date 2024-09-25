locals {
  # THINKERのユーザー
  attachment_thinker_users = [
    "RYOTA_HASEGAWA",
    "HUNAG",
    "ANALYST_HASEGAWA",
    "ENGINEER_HASEGAWA"
  ]
}

########################
# grant on account
########################
module "grant_on_account" {
  source = "../../modules/grant_on_account"
  providers = {
    snowflake = snowflake.terraform
  }

  apply_authentication_policy_role_name = module.fr_manager.name
  create_network_policy_role_name       = module.fr_manager.name
}

########################
# Network Rule
# Network Ruleは、ネットワークアクセスを制御するためのルールです。
########################
module "network_rule_thinker" {
  source = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.fr_manager
  }

  rule_name = "NETWORK_RULE_THINKER"
  databse   = module.security_db.name
  schema    = module.security_db_network_schema.name
  comment   = "株式会社シンカー グローバルIP"
  type      = "IPV4"
  mode      = "INGRESS"
  value_list = [
    "133.242.237.194", #interlink
    "35.73.194.191"    #cloudflare
  ]
}

########################
# Network Policy
########################
locals {
  attachment_users = ["HUNAG"]
}
module "network_policy_thinker" {
  source = "../../modules/network_policy"
  providers = {
    snowflake = snowflake.fr_manager
  }

  policy_name = "NETWORK_POLICY_THINKER"
  comment     = "株式会社シンカー ネットワークポリシー"

  allowed_network_rule_list = [
    module.network_rule_thinker.fully_qualified_name
  ]

  blocked_network_rule_list = []

  set_for_account = true
  #users           = local.attachment_thinker_users

  depends_on = [module.grant_on_account]
}
