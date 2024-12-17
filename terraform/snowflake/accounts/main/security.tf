########################
# Password Policy
# Doc: https://docs.snowflake.com/en/sql-reference/sql/create-password-policy
########################
module "password_policy" {
  source = "../../modules/password_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  password_policy_name = "PASSWORD_POLICY_DEFAULT"
  database             = module.security_db.name
  schema               = module.security_db_authentication_schema.name
  # comment              = "デフォルトのパスワードポリシー"
  min_length = 14
}

########################
# Network Rule
# Network Ruleは、ネットワークアクセスを制御するためのルールです。
########################
module "network_rule_thinker" {
  source = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  rule_name = "NETWORK_RULE_THINKER"
  database  = module.security_db.name
  schema    = module.security_db_network_schema.name
  comment   = "株式会社シンカー グローバルIP 許可リスト"
  type      = "IPV4"
  mode      = "INGRESS"
  value_list = [
    "150.195.218.240", # cato networks - Tokyo
    "150.195.212.98"   # cato networks - Osaka 
  ]
}

module "network_rule_trocco" {
  source = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  rule_name = "NETWORK_RULE_TROCCO"
  database  = module.security_db.name
  schema    = module.security_db_network_schema.name
  comment   = "TROCCO グローバルIP 許可リスト"
  type      = "IPV4"
  mode      = "INGRESS"
  value_list = [
    "18.182.232.211",
    "13.231.52.164",
    "3.113.216.138"
  ]
}

# Tableau cloud IP address list
# Doc: https://help.tableau.com/current/pro/desktop/en-us/publish_tableau_online_ip_authorization.htm
module "network_rule_tableau_cloud_us_west_2" {
  source = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  rule_name = "NETWORK_RULE_TABLEAU_CLOUD_US_WEST_2"
  database  = module.security_db.name
  schema    = module.security_db_network_schema.name
  comment   = "TABLEAU CLOUD 許可リスト"
  type      = "IPV4"
  mode      = "INGRESS"
  value_list = [
    "155.226.128.0/21", # Tableau Cloud IP Range
    "34.214.85.34",     # Hyperforce への移行前 IP Address
    "34.214.85.244"     # Hyperforce への移行前 IP Address
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

  allowed_network_rule_list = [
    module.network_rule_thinker.fully_qualified_name
  ]

  blocked_network_rule_list = [
  ]

  set_for_account = true
  users           = []
}

module "network_policy_trocco_user" {
  source = "../../modules/network_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  policy_name = "NETWORK_POLICY_TROCCO_USER"
  comment     = "TROCCO USER ネットワークポリシー"

  allowed_network_rule_list = [
    module.network_rule_trocco.fully_qualified_name
  ]

  blocked_network_rule_list = []

  set_for_account = false
  users = [
    "TROCCO_USER",
  ]
}

module "network_policy_tableau_user" {
  source = "../../modules/network_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  policy_name = "NETWORK_POLICY_TABLEAU_USER"
  comment     = "TABLEAU USER ネットワークポリシー"

  allowed_network_rule_list = [
    module.network_rule_tableau_cloud_us_west_2.fully_qualified_name
  ]

  blocked_network_rule_list = []

  set_for_account = false
  users = [
    "TABLEAU_USER"
  ]
}
