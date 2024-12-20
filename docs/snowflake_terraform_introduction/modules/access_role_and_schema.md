# 概要

- 「スキーマを作成するリソース」と「作成するスキーマに関連するAccess Roleのリソース」をModuleとして定義しています。

## 各種ファイル

## main.tf

各種リソースをまとめて定義しています。

- 「テーブルごとにアクセス権を与えず、スキーマレベルでアクセス権を管理する」考えでModuleを定義したので、スキーマ内の全テーブルへのGRANTと今後増えるテーブルに対するFUTURE GRANTを行っている
- Database Roleを使うことで、ユーザーがSnowsight上でAccess Roleに切り替えができない
  - （ユーザーに表示されるロールが無駄に増えないメリットがある）
- このAccess Roleを付与したいFunctional Roleを**下記変数**でModule利用時に受け取ることで、作成したAccess RoleのFunctional RoleへのGRANTもまとめて行う
  - `manager_ar_to_fr_set`
  - `transformer_ar_to_fr_set`
  - `read_only_ar_to_fr_set`
  - `etl_tool_ar_to_fr_set`
- 作成したAccess RoleはSYSADMINにもGRANTすることで、SYSADMINが全てのオブジェクトにアクセスできるようにする

- **CODE**

    ```toml
    ########################
    # offical document
    # priviliges: https://docs.snowflake.com/ja/user-guide/security-access-control-privileges#schema-privileges
    ########################
    
    # スキーマの作成
    resource "snowflake_schema" "this" {
      database            = var.database_name
      name                = var.schema_name
      comment             = var.comment
      data_retention_days = var.data_retention_days
    
      is_managed   = var.is_managed
      is_transient = var.is_transient
    }
    ```

    ```toml
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
    ```

    ```toml
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
        "CREATE ICEBERG TABLE", "CREATE VIEW", "CREATE MATERIALIZED VIEW",
        "CREATE STAGE", "CREATE FILE FORMAT", "CREATE SEQUENCE", "CREATE FUNCTION", "CREATE PIPE",
        "CREATE STREAM", "CREATE TAG", "CREATE TASK", "CREATE PROCEDURE",
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
    ```

    ```toml
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
    ```

    ```toml
    ########################
    # ETL Tools Role Group
    ########################
    
    # 対象のデータベースに対するRead/WriteのAccess Roleを作成
    resource "snowflake_database_role" "etl_tool_ar" {
      database = snowflake_schema.this.database
      name     = "_SCM_${snowflake_schema.this.name}_ETL_TOOL_AR"
      comment  = "Etl tools role of ${snowflake_schema.this.name} schema"
    
      depends_on = [snowflake_schema.this]
    }
    
    # Read WriteのAccess Roleへのスキーマ権限のgrant
    resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool_schema" {
      privileges = [
        "USAGE", "CREATE STAGE", "CREATE TABLE", "CREATE VIEW"
      ]
      database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_ar.name}\""
      on_schema {
        schema_name = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
      }
    
      depends_on = [snowflake_database_role.etl_tool_ar]
    }
    
    # Read WriteのAccess Roleへのスキーマ内すべてのテーブル権限のgrant
    resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool_all_tables" {
      privileges         = ["SELECT", "INSERT", "UPDATE", "TRUNCATE", "DELETE", "REFERENCES"]
      database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_ar.name}\""
      on_schema_object {
        all {
          object_type_plural = "TABLES"
          in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
        }
      }
    
      depends_on = [snowflake_database_role.etl_tool_ar]
    }
    
    # Read WriteのAccess Roleへのスキーマ内すべてのテーブル権限のfuture grant
    resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool_future_tables" {
      privileges         = ["SELECT", "INSERT", "UPDATE", "TRUNCATE", "DELETE", "REFERENCES"]
      database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_ar.name}\""
      on_schema_object {
        future {
          object_type_plural = "TABLES"
          in_schema          = "\"${snowflake_schema.this.database}\".\"${snowflake_schema.this.name}\""
        }
      }
    
      depends_on = [snowflake_database_role.etl_tool_ar]
    }
    
    # Functional RoleにRead/WriteのAccess Roleをgrant
    resource "snowflake_grant_database_role" "grant_etl_tool_ar_to_fr" {
      for_each = var.etl_tool_ar_to_fr_set
    
      database_role_name = "\"${snowflake_schema.this.database}\".\"${snowflake_database_role.etl_tool_ar.name}\""
      parent_role_name   = each.value
    
      depends_on = [snowflake_database_role.etl_tool_ar]
    }
    ```

    ```toml
    ########################
    # SYSADMINにAccess Roleをgrant
    ########################
    resource "snowflake_grant_database_role" "grant_to_sysadmin" {
      for_each = toset([
        snowflake_database_role.manager_ar.name,
        snowflake_database_role.transformer_ar.name,
        snowflake_database_role.read_only_ar.name,
        snowflake_database_role.etl_tool_ar.name
      ])
      database_role_name = "\"${snowflake_schema.this.database}\".\"${each.value}\""
      parent_role_name   = "SYSADMIN"
    
      depends_on = [
        snowflake_database_role.manager_ar,
        snowflake_database_role.transformer_ar,
        snowflake_database_role.read_only_ar,
        snowflake_database_role.etl_tool_ar
      ]
    }
    ```

## **outputs.tf**

- 他のModuleから作成したスキーマ名を参照できるように、**`name`**だけoutputとして定義しています。

- CODE

    ```toml
    output "name" {
      description = "Name of the schema."
      value       = snowflake_schema.this.name
    }
    ```

## **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`snowflake_schema`**リソースで使う値を定義しています。
- Access Roleを付与したいFunctional RoleをModule使用時に受け取るために下記も定義しています。
  - `manager_ar_to_fr_set`
  - `transformer_ar_to_fr_set`
  - `etl_tool_ar_to_fr_set`
  - `read_only_ar_to_fr_set`

- **CODE**

    ```toml
    variable "schema_name" {
      description = "Name of the schema"
      type        = string
      default     = null
    }
    
    variable "database_name" {
      description = "Name of the database to which the Schema belongs"
      type        = string
      default     = null
    }
    
    variable "comment" {
      description = "Write description for the schema"
      type        = string
      default     = null
    }
    
    variable "data_retention_days" {
      description = "Time travelable period to be set for the entire schema."
      type        = number
      default     = null
    }
    
    variable "is_managed" {
      description = "Specifies a managed schema."
      type        = bool
      default     = false
    }
    
    variable "is_transient" {
      description = "Specifies a schema as transient."
      type        = bool
      default     = false
    }
    
    variable "manager_ar_to_fr_set" {
      description = "Set of functional role for grant manager access role"
      type        = set(string)
      default     = []
    }
    
    variable "transformer_ar_to_fr_set" {
      description = "Set of functional role for grant read/write access role"
      type        = set(string)
      default     = []
    }
    
    variable "etl_tool_ar_to_fr_set" {
      description = "Set of functional role for grant read/write access role"
      type        = set(string)
      default     = []
    }
    
    variable "read_only_ar_to_fr_set" {
      description = "Set of functional role for grant read only access role"
      type        = set(string)
      default     = []
    }
    
    ```
