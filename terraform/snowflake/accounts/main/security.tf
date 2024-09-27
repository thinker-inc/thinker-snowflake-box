########################
# grant on account
########################
module "grant_on_account" {
  source = "../../modules/grant_on_account"
  providers = {
    snowflake = snowflake.security_admin
  }

  security_admin_policy_role_name = module.fr_security_manager.name
}



########################
# Network Rule
# Network Ruleは、ネットワークアクセスを制御するためのルールです。
########################
module "network_rule_block_public_access" {
  source = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  rule_name = "NETWORK_RULE_BLOCK_PUBLIC_ACCESS"
  databse   = module.security_db.name
  schema    = module.security_db_network_schema.name
  comment   = "全てのパブリックアクセスをブロック"
  type      = "IPV4"
  mode      = "INGRESS"
  value_list = [
    "0.0.0.0/0"
  ]
}

module "network_rule_thinker" {
  source = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.fr_security_manager
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

module "network_rule_trocco" {
  source = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  rule_name = "NETWORK_RULE_TROCCO"
  databse   = module.security_db.name
  schema    = module.security_db_network_schema.name
  comment   = "TROCCO グローバルIP"
  type      = "IPV4"
  mode      = "INGRESS"
  value_list = [
    "18.182.232.211",
    "13.231.52.164",
    "3.113.216.138"
  ]
}

########################
# Network Policy
########################
module "network_policy_default" {
  source = "../../modules/network_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  policy_name = "NETWORK_POLICY_DEFAULT"
  comment     = "Snowflake デフォルト ネットワークポリシー"

  allowed_network_rule_list = []

  blocked_network_rule_list = [
    module.network_rule_block_public_access.fully_qualified_name
  ]

  set_for_account = true
  users           = []
}

module "network_policy_thinker" {
  source = "../../modules/network_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  policy_name = "NETWORK_POLICY_THINKER"
  comment     = "株式会社シンカー ネットワークポリシー"

  allowed_network_rule_list = [
    module.network_rule_thinker.fully_qualified_name
  ]

  blocked_network_rule_list = []

  set_for_account = false
  users           = local.attachment_thinker_users
}

module "network_policy_trocco" {
  source = "../../modules/network_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  policy_name = "NETWORK_POLICY_TROCCO"
  comment     = "TROCCO ネットワークポリシー"

  allowed_network_rule_list = [
    module.network_rule_trocco.fully_qualified_name
  ]

  blocked_network_rule_list = []

  set_for_account = false
  users           = []
}
