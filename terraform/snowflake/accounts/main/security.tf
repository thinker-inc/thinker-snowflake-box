########################
# Password Policy
# Doc: https://docs.snowflake.com/en/sql-reference/sql/create-password-policy
########################
module "password_policy" {
  depends_on = [module.security_db_authentication_schema]
  source     = "../../modules/password_policy"
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
  depends_on = [module.security_db_network_schema]
  source     = "../../modules/network_rule"
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
  depends_on = [module.security_db_network_schema]
  source     = "../../modules/network_rule"
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
    "3.113.216.138",
    "57.181.137.181",
    "54.250.45.100"
  ]
}


# Tableau Cloud用ネットワークルール
module "network_rule_tableau_cloud_us_west_2" {
  depends_on = [module.security_db_network_schema]
  source     = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  rule_name = "NETWORK_RULE_TABLEAU_CLOUD_US_WEST_2"
  database  = module.security_db.name
  schema    = module.security_db_network_schema.name
  comment   = "TABLEAU CLOUD 許可リスト（AWS us-west-2）"
  type      = "IPV4"
  mode      = "INGRESS"
  value_list = [
    "155.226.128.0/21", # us-west-2 Tableau Cloud IP Range
    "34.214.85.34",     # us-west-2 Hyperforce への移行前 IP Address
    "34.214.85.244"     # us-west-2 Hyperforce への移行前 IP Address
  ]
}

########################
# Looker Studio
########################
module "network_rule_looker_studio" {
  depends_on = [module.security_db_network_schema]
  source     = "../../modules/network_rule"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  # NOTE:
  # - Looker Studio は SaaS 側（Google 管理インフラ）から Snowflake に直接接続するため、
  #   送信元IPを社内/VPN（Cato）の固定IPに寄せる方針が取れない。
  # - 送信元IP変動による接続失敗を避ける目的で、例外的に IPv4 を許可している。
  # - その代わり、影響範囲を最小化するため、本 Network Rule を参照する Network Policy は
  #   `LOOKER_STUDIO_USER` のみにアタッチしている（アカウント全体には適用しない）。
  rule_name = "NETWORK_RULE_LOOKER_STUDIO"
  database  = module.security_db.name
  schema    = module.security_db_network_schema.name
  comment   = "LOOKER STUDIO 許可リスト（Google側送信元IPが変動するためIPv4を許可）"
  type      = "IPV4"
  mode      = "INGRESS"
  value_list = [
    "0.0.0.0/0"
  ]
}

########################
# Network Policy
########################
module "network_policy_default" {
  depends_on = [module.network_rule_thinker]
  source     = "../../modules/network_policy"
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
  depends_on = [module.network_rule_trocco, module.trocco_user]
  source     = "../../modules/network_policy"
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

# Tableau統合用ネットワークポリシー
module "network_policy_tableau" {
  depends_on = [module.network_rule_tableau_cloud_us_west_2, module.network_rule_thinker]
  source     = "../../modules/network_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  policy_name = "NETWORK_POLICY_TABLEAU"
  comment     = "TABLEAU 統合ネットワークポリシー（Desktop + Cloud）"

  allowed_network_rule_list = [
    module.network_rule_tableau_cloud_us_west_2.fully_qualified_name,
    module.network_rule_thinker.fully_qualified_name
  ]

  blocked_network_rule_list = []

  set_for_account = false
  users           = concat(local.manager, local.analytics_users)
}

module "network_policy_looker_studio" {
  depends_on = [module.network_rule_looker_studio, module.network_rule_thinker]
  source     = "../../modules/network_policy"
  providers = {
    snowflake = snowflake.fr_security_manager
  }

  policy_name = "NETWORK_POLICY_LOOKER_STUDIO"
  comment     = "LOOKER STUDIO ネットワークポリシー"

  allowed_network_rule_list = [
    module.network_rule_looker_studio.fully_qualified_name,
    module.network_rule_thinker.fully_qualified_name
  ]

  blocked_network_rule_list = []

  set_for_account = false
  users = [
    "LOOKER_STUDIO_USER"
  ]
}

