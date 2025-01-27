# データベースの作成
resource "snowflake_database" "this" {
  name                        = var.database_name
  comment                     = var.comment
  data_retention_time_in_days = var.data_retention_time_in_days

  # replicationやshare周りのoptionは割愛
}

########################
# MANAGER
# Manager(admin) Access Role
########################
# 対象のデータベースに対するManagerのAccess Roleを作成
resource "snowflake_database_role" "manager_ar" {
  database = snowflake_database.this.name
  name     = "_DATABASE_${snowflake_database.this.name}_MANAGER_AR"
  comment  = "Manager role of ${snowflake_database.this.name}"

  depends_on = [snowflake_database.this]
}

# ManagerのAccess Roleへの権限のgrant - 全ての権限を付与[ALL PRIVILEGES]
resource "snowflake_grant_privileges_to_database_role" "grant_manager" {
  all_privileges     = true
  database_role_name = snowflake_database_role.manager_ar.fully_qualified_name
  on_database        = snowflake_database.this.name

  depends_on = [snowflake_database_role.manager_ar]
}

# Functional RoleにManagerのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_manager_ar_to_fr" {
  for_each           = var.manager_ar_to_fr_set
  database_role_name = snowflake_database_role.manager_ar.fully_qualified_name
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.manager_ar]
}

########################
# TRANSFORMER
# Transformer (Read/Write) Access Role
########################
# 対象のデータベースに対するTransformerのAccess Roleを作成
resource "snowflake_database_role" "transformer_ar" {
  database = snowflake_database.this.name
  name     = "_DATABASE_${snowflake_database.this.name}_TRANSFORMER_AR"
  comment  = "Transformer role of ${snowflake_database.this.name}"

  depends_on = [snowflake_database.this]
}

# TransformerのAccess Roleへの権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_transformer" {
  privileges         = ["USAGE", "MONITOR", "CREATE SCHEMA"]
  database_role_name = snowflake_database_role.transformer_ar.fully_qualified_name
  on_database        = snowflake_database.this.name

  depends_on = [snowflake_database_role.transformer_ar]
}

# Functional RoleにRead/WriteのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_transformer_ar_to_fr" {
  for_each = var.transformer_ar_to_fr_set

  database_role_name = snowflake_database_role.transformer_ar.fully_qualified_name
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.transformer_ar]
}

########################
# Read Only Access Role
########################
# 対象のデータベースに対するRead OnlyのAccess Roleを作成
resource "snowflake_database_role" "read_only_ar" {
  database = snowflake_database.this.name
  name     = "_DATABASE_${snowflake_database.this.name}_READ_ONLY_AR"
  comment  = "Read only role of ${snowflake_database.this.name}"

  depends_on = [snowflake_database.this]
}

# Read OnlyのAccess Roleへの権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_read_only" {
  privileges         = ["USAGE", "MONITOR"]
  database_role_name = snowflake_database_role.read_only_ar.fully_qualified_name
  on_database        = snowflake_database.this.name

  depends_on = [snowflake_database_role.read_only_ar]
}

# Functional RoleにRead OnlyのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_readonly_ar_to_fr" {
  for_each = var.read_only_ar_to_fr_set

  database_role_name = snowflake_database_role.read_only_ar.fully_qualified_name
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.read_only_ar]
}


########################
# ETL Tools Import Access Role
########################
# 対象のデータベースに対するETL TOOLのAccess Roleを作成
resource "snowflake_database_role" "sr_trocco_import_ar" {
  database = snowflake_database.this.name
  name     = "_DATABASE_${snowflake_database.this.name}_SR_TROCCO_IMPORT_AR"
  comment  = "Etl tools import role of ${snowflake_database.this.name}"

  depends_on = [snowflake_database.this]
}

# Etl tools importのAccess Roleへの権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_sr_trocco_import" {
  privileges         = ["USAGE", "MONITOR", "CREATE SCHEMA"]
  database_role_name = snowflake_database_role.sr_trocco_import_ar.fully_qualified_name
  on_database        = snowflake_database.this.name

  depends_on = [snowflake_database_role.sr_trocco_import_ar]
}

# Functional RoleにRead/WriteのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_sr_trocco_import_ar_to_fr" {
  for_each = var.sr_import_ar_to_fr_set

  database_role_name = snowflake_database_role.sr_trocco_import_ar.fully_qualified_name
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.sr_trocco_import_ar]
}

########################
# ETL Tools Transform Access Role
########################
# 対象のデータベースに対するETL TOOLのAccess Roleを作成
resource "snowflake_database_role" "sr_trocco_transform_ar" {
  database = snowflake_database.this.name
  name     = "_DATABASE_${snowflake_database.this.name}_SR_TROCCO_TRANSFORM_AR"
  comment  = "Etl tools transform role of ${snowflake_database.this.name}"

  depends_on = [snowflake_database.this]
}

# Etl tools transformのAccess Roleへの権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_sr_trocco_transform" {
  privileges         = ["USAGE", "MONITOR"]
  database_role_name = snowflake_database_role.sr_trocco_transform_ar.fully_qualified_name
  on_database        = snowflake_database.this.name

  depends_on = [snowflake_database_role.sr_trocco_transform_ar]
}

# Functional RoleにRead/WriteのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_sr_trocco_transform_ar_to_fr" {
  for_each = var.sr_transform_ar_to_fr_set

  database_role_name = snowflake_database_role.sr_trocco_transform_ar.fully_qualified_name
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.sr_trocco_transform_ar]
}

########################
# SYSADMINにAccess Roleをgrant
########################

resource "snowflake_grant_database_role" "grant_to_sysadmin" {
  for_each = toset([
    snowflake_database_role.manager_ar.name,
    snowflake_database_role.transformer_ar.name,
    snowflake_database_role.read_only_ar.name,
    snowflake_database_role.sr_trocco_import_ar.name,
    snowflake_database_role.sr_trocco_transform_ar.name
  ])

  database_role_name = "\"${snowflake_database.this.name}\".\"${each.value}\""
  parent_role_name   = "SYSADMIN"

  depends_on = [
    snowflake_database_role.manager_ar,
    snowflake_database_role.transformer_ar,
    snowflake_database_role.read_only_ar,
    snowflake_database_role.sr_trocco_import_ar,
    snowflake_database_role.sr_trocco_transform_ar
  ]
}

