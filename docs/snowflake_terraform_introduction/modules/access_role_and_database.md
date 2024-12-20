# 概要

- 「データベースを作成するリソース」と「作成するデータベースに関連するAccess Roleのリソース」をModuleとして定義しています。

## 各種ファイル

## main.tf

各種リソースをまとめて定義しています。

- Database Roleを使うことで、ユーザーがSnowsight上でAccess Roleに切り替えができない
  - （ユーザーに表示されるロールが無駄に増えないメリットがある）
- Access Roleを付与したいFunctional Roleを**下記変数**でModule利用時に受け取ることで、作成したAccess RoleのFunctional RoleへのGRANTもまとめて行う
  - `manager_ar_to_fr_set`
  - `transformer_ar_to_fr_set`
  - `read_only_ar_to_fr_set`
  - `etl_tool_ar_to_fr_set`
- 作成したAccess RoleはSYSADMINにもGRANTすることで、SYSADMINが全てのオブジェクトにアクセスできるようにする

- **CODE**

    ```toml
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
      database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.manager_ar.name}\""
      on_database        = snowflake_database.this.name
    
      depends_on = [snowflake_database_role.manager_ar]
    }
    
    # Functional RoleにManagerのAccess Roleをgrant
    resource "snowflake_grant_database_role" "grant_manager_ar_to_fr" {
      for_each = var.manager_ar_to_fr_set
    
      database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.manager_ar.name}\""
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
      database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.transformer_ar.name}\""
      on_database        = snowflake_database.this.name
    
      depends_on = [snowflake_database_role.transformer_ar]
    }
    
    # Functional RoleにRead/WriteのAccess Roleをgrant
    resource "snowflake_grant_database_role" "grant_transformer_ar_to_fr" {
      for_each = var.transformer_ar_to_fr_set
    
      database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.transformer_ar.name}\""
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
      database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.read_only_ar.name}\""
      on_database        = snowflake_database.this.name
    
      depends_on = [snowflake_database_role.read_only_ar]
    }
    
    # Functional RoleにRead OnlyのAccess Roleをgrant
    resource "snowflake_grant_database_role" "grant_readonly_ar_to_fr" {
      for_each = var.read_only_ar_to_fr_set
    
      database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.read_only_ar.name}\""
      parent_role_name   = each.value
    
      depends_on = [snowflake_database_role.read_only_ar]
    }
    
    ########################
    # ETL Tools Access Role
    ########################
    # 対象のデータベースに対するETL TOOLのAccess Roleを作成
    resource "snowflake_database_role" "etl_tool_ar" {
      database = snowflake_database.this.name
      name     = "_DATABASE_${snowflake_database.this.name}_ETL_TOOL_AR"
      comment  = "Etl tools role of ${snowflake_database.this.name}"
    
      depends_on = [snowflake_database.this]
    }
    
    # Etl toolsのAccess Roleへの権限のgrant
    resource "snowflake_grant_privileges_to_database_role" "grant_etl_tool" {
      privileges         = ["USAGE", "MONITOR", "CREATE SCHEMA"]
      database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.etl_tool_ar.name}\""
      on_database        = snowflake_database.this.name
    
      depends_on = [snowflake_database_role.etl_tool_ar]
    }
    
    # Functional RoleにRead/WriteのAccess Roleをgrant
    resource "snowflake_grant_database_role" "grant_etl_tool_ar_to_fr" {
      for_each = var.etl_tool_ar_to_fr_set
    
      database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.etl_tool_ar.name}\""
      parent_role_name   = each.value
    
      depends_on = [snowflake_database_role.etl_tool_ar]
    }
    
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
      database_role_name = "\"${snowflake_database.this.name}\".\"${each.value}\""
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

他のModuleから作成したデータベース名を参照できるように、**`name`**だけoutputとして定義しています。

- **CODE**

    ```toml
    output "name" {
      description = "Name of the database."
      value       = snowflake_database.this.name
    }
    ```

## **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`snowflake_database`**リソースで使う値を定義しています。
- Access Roleを付与したいFunctional RoleをModule使用時に受け取るために下記も定義しています。
  - `manager_ar_to_fr_set`
  - `transformer_ar_to_fr_set`
  - `etl_tool_ar_to_fr_set`
  - `read_only_ar_to_fr_set`

- **CODE**

    ```toml
    variable "database_name" {
      description = "Name of the database"
      type        = string
      default     = null
    }
    
    variable "comment" {
      description = "Write description for the database"
      type        = string
      default     = null
    }
    
    variable "data_retention_time_in_days" {
      description = "Time travelable period to be set for the entire database."
      type        = number
      default     = null
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
