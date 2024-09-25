########################
# offical document
# priviliges: https://docs.snowflake.com/ja/user-guide/security-access-control-privileges#schema-privileges
########################

# スキーマの作成
resource "snowflake_schema" "this" {
  database                    = var.database_name
  name                        = var.schema_name
  comment                     = var.comment
  data_retention_time_in_days = var.data_retention_time_in_days

  with_managed_access = var.with_managed_access
  is_transient        = var.is_transient
}

########################
# MANAGER
# Manager(admin) Role Group
########################

# 対象のデータベースに対するManagerのAccess Roleを作成
resource "snowflake_database_role" "manager_ar" {
  database = snowflake_schema.this.database
  name     = "_SCM_${snowflake_schema.this.name}_MANAGER_AR"
  comment  = "Manager role of ${snowflake_schema.this.name} schema"

  depends_on = [snowflake_schema.this]
}

# ManagerのAccess Roleへのスキーマ権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_manager_schema" {
  all_privileges     = true
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.manager_ar.name}\""
  on_schema {
    schema_name = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
  }

  depends_on = [snowflake_database_role.manager_ar]
}

# ManagerのAccess Roleへのスキーマ内すべてのテーブル権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_manager_all_tables" {
  all_privileges     = true
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.manager_ar.name}\""
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.manager_ar]
}

# Read WriteのAccess Roleへのスキーマ内すべてのテーブル権限のfuture grant
resource "snowflake_grant_privileges_to_database_role" "grant_manager_future_tables" {
  all_privileges     = true
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.manager_ar.name}\""
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.manager_ar]
}

# Functional RoleにRead/WriteのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_manager_ar_to_fr" {
  for_each = var.manager_ar_to_fr_set

  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.manager_ar.name}\""
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.manager_ar]
}

########################
# TRANSFORMER
# Transformer (Read/Write)  Role Group
########################

# 対象のデータベースに対するRead/WriteのAccess Roleを作成
resource "snowflake_database_role" "transformer_ar" {
  database = snowflake_schema.this.database
  name     = "_SCM_${snowflake_schema.this.name}_TRANSFORMER_AR"
  comment  = "Transformer role of ${snowflake_schema.this.name} schema"

  depends_on = [snowflake_schema.this]
}

# Read WriteのAccess Roleへのスキーマ権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_transformer_schema" {
  privileges = [
    "USAGE", "MONITOR", "CREATE TABLE", "CREATE DYNAMIC TABLE", "CREATE EXTERNAL TABLE",
    "CREATE FUNCTION", "CREATE VIEW", "CREATE MATERIALIZED VIEW"
    //"CREATE ICEBERG TABLE",
    //"CREATE STAGE", "CREATE FILE FORMAT", "CREATE SEQUENCE", "CREATE PIPE",
    //"CREATE STREAM", "CREATE TAG", "CREATE TASK", "CREATE PROCEDURE",
    //"CREATE MODEL", "CREATE SNOWFLAKE.ML.FORECAST", "CREATE SNOWFLAKE.ML.ANOMALY_DETECTION"
    //"CREATE HYBRID TABLE"
  ]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.transformer_ar.name}\""
  on_schema {
    schema_name = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
  }

  depends_on = [snowflake_database_role.transformer_ar]
}

# Read WriteのAccess Roleへのスキーマ内すべてのテーブル権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_transformer_all_tables" {
  privileges         = ["SELECT", "INSERT", "UPDATE", "TRUNCATE", "DELETE", "REFERENCES"]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.transformer_ar.name}\""
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.transformer_ar]
}

# Read WriteのAccess Roleへのスキーマ内すべてのテーブル権限のfuture grant
resource "snowflake_grant_privileges_to_database_role" "grant_transformer_future_tables" {
  privileges         = ["SELECT", "INSERT", "UPDATE", "TRUNCATE", "DELETE", "REFERENCES"]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.transformer_ar.name}\""
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.transformer_ar]
}

# Functional RoleにRead/WriteのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_transformer_ar_to_fr" {
  for_each = var.transformer_ar_to_fr_set

  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.transformer_ar.name}\""
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.transformer_ar]
}

########################
# Read Only Role Group
########################

# 対象のスキーマに対するRead OnlyのAccess Roleを作成
resource "snowflake_database_role" "read_only_ar" {
  database = snowflake_schema.this.database
  name     = "_SCM_${snowflake_schema.this.name}_READ_ONLY_AR"
  comment  = "Read only role of ${snowflake_schema.this.name} schema"

  depends_on = [snowflake_schema.this]
}

# Read OnlyのAccess Roleへのスキーマ権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_read_only_schema" {
  privileges         = ["USAGE", "MONITOR"]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.read_only_ar.name}\""
  on_schema {
    schema_name = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
  }

  depends_on = [snowflake_database_role.read_only_ar]
}

# Read OnlyのAccess Roleへのスキーマ内すべてのテーブル権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_read_only_all_tables" {
  privileges         = ["SELECT"]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.read_only_ar.name}\""
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.read_only_ar]
}

# Read OnlyのAccess Roleへのスキーマ内すべてのテーブル権限のfuture grant
resource "snowflake_grant_privileges_to_database_role" "grant_read_only_future_tables" {
  privileges         = ["SELECT"]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.read_only_ar.name}\""
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.read_only_ar]
}


# Functional RoleにRead OnlyのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_readonly_ar_to_fr" {
  for_each = var.read_only_ar_to_fr_set

  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.read_only_ar.name}\""
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.read_only_ar]
}

########################
# ETL Tools Import Role Group
########################

# 対象のデータベースに対するRead/WriteのAccess Roleを作成
resource "snowflake_database_role" "etl_tool_import_ar" {
  database = snowflake_schema.this.database
  name     = "_SCM_${snowflake_schema.this.name}_ETL_TOOL_IMPORT_AR"
  comment  = "Etl tools import role of ${snowflake_schema.this.name} schema"

  depends_on = [snowflake_schema.this]
}

# Read WriteのAccess Roleへのスキーマ権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool_import_schema" {
  privileges = [
    "USAGE", "CREATE STAGE", "CREATE TABLE"
  ]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_import_ar.name}\""
  on_schema {
    schema_name = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
  }

  depends_on = [snowflake_database_role.etl_tool_import_ar]
}

# Read WriteのAccess Roleへのスキーマ内すべてのテーブル権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool_import_all_tables" {
  privileges         = ["SELECT", "INSERT", "UPDATE", "TRUNCATE", "DELETE"]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_import_ar.name}\""
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.etl_tool_import_ar]
}

# Read WriteのAccess Roleへのスキーマ内すべてのテーブル権限のfuture grant
resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool_import_future_tables" {
  privileges         = ["SELECT", "INSERT", "UPDATE", "TRUNCATE", "DELETE"]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_import_ar.name}\""
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.etl_tool_import_ar]
}

# Functional RoleにRead/WriteのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_etl_tool_import_ar_to_fr" {
  for_each = var.etl_tool_import_ar_to_fr_set

  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_import_ar.name}\""
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.etl_tool_import_ar]
}

########################
# ETL Tools Transform Role Group
########################

# 対象のデータベースに対するRead/WriteのAccess Roleを作成
resource "snowflake_database_role" "etl_tool_transform_ar" {
  database = snowflake_schema.this.database
  name     = "_SCM_${snowflake_schema.this.name}_ETL_TOOL_TRANSFORM_AR"
  comment  = "Etl tools transform role of ${snowflake_schema.this.name} schema"

  depends_on = [snowflake_schema.this]
}

# Read WriteのAccess Roleへのスキーマ権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool_transform_schema" {
  privileges = [
    "USAGE", "CREATE TABLE", "CREATE VIEW"
  ]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_transform_ar.name}\""
  on_schema {
    schema_name = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
  }

  depends_on = [snowflake_database_role.etl_tool_transform_ar]
}

# Read WriteのAccess Roleへのスキーマ内すべてのテーブル権限のgrant
resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool_transform_all_tables" {
  privileges         = ["SELECT", "INSERT", "UPDATE", "TRUNCATE", "DELETE", "REFERENCES"]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_transform_ar.name}\""
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.etl_tool_transform_ar]
}

# Read WriteのAccess Roleへのスキーマ内すべてのテーブル権限のfuture grant
resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool_transform_future_tables" {
  privileges         = ["SELECT", "INSERT", "UPDATE", "TRUNCATE", "DELETE", "REFERENCES"]
  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_transform_ar.name}\""
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
    }
  }

  depends_on = [snowflake_database_role.etl_tool_transform_ar]
}

# Functional RoleにRead/WriteのAccess Roleをgrant
resource "snowflake_grant_database_role" "grant_etl_tool_transform_ar_to_fr" {
  for_each = var.etl_tool_transform_ar_to_fr_set

  database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_transform_ar.name}\""
  parent_role_name   = each.value

  depends_on = [snowflake_database_role.etl_tool_transform_ar]
}

########################
# SYSADMINにAccess Roleをgrant
########################
resource "snowflake_grant_database_role" "grant_to_sysadmin" {
  for_each = toset([
    snowflake_database_role.manager_ar.name,
    snowflake_database_role.transformer_ar.name,
    snowflake_database_role.read_only_ar.name,
    snowflake_database_role.etl_tool_import_ar.name,
    snowflake_database_role.etl_tool_transform_ar.name
  ])
  database_role_name = "\"${snowflake_schema.this.database}\".\"${each.value}\""
  parent_role_name   = "SYSADMIN"

  depends_on = [
    snowflake_database_role.manager_ar,
    snowflake_database_role.transformer_ar,
    snowflake_database_role.read_only_ar,
    snowflake_database_role.etl_tool_import_ar,
    snowflake_database_role.etl_tool_transform_ar
  ]
}
