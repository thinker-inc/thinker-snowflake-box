locals {

  # Snowflake Roles
  security_role_name = "FR_SECURITY_MANAGER"

  # Snowflake Users
  initial_user_password = "2tK4Z@fZAwkjqzDZbZTh"
  _users_yml            = yamldecode(file("${path.root}/definitions/users.yml"))
  users                 = local._users_yml["users"] != null ? local._users_yml["users"] : []

  # マネージャーグループ
  manager = [
    "RYOTA_HASEGAWA",
    "HUNAG"
  ]

  # データエンジニアグループ
  data_engineer = concat(
    local.manager,
    [
      "ENGINEER_HASEGAWA"
    ]
  )

  # データサイエンティストグループ
  data_scientist = concat(
    local.manager,
    [
      "SCIENTIST_HASEGAWA"
    ]
  )

  # データアナリストグループ
  data_analyst = concat(
    local.manager,
    [
      "ANALYST_HASEGAWA"
    ]
  )

  # Tableauグループ
  service_tableau = concat(
    local.manager,
    [
      "TABLEAU_USER"
    ]
  )

  # TROCCOグループ
  service_trocco = concat(
    local.manager,
    [
      "TROCCO_USER"
    ]
  )

  # Remove double quotes from fully qualified name
  # parquet_file_format_fullqualified_name = replace(module.parquet_file_format.fully_qualified_name, "\"", "")
}
