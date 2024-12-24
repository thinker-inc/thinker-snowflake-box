# 概要

- 「ウェアハウスを作成するリソース」と「作成するウェアハウスに関連するAccess Roleのリソース」をModuleとして定義しています。

## 各種ファイル

## main.tf

各種リソースをまとめて定義しています。

- ウェアハウスの権限は**Database RoleにGRANTできない**ため、普通のロールを使っている。
  - ただ、Access Roleであることがひと目でわかるように**`_WAREHOUSE_<ウェアハウス名>_USAGE_AR`**のように、先頭に**`_`**をつけている
- Access Roleを付与したいFunctional Roleを**下記変数**でModule利用時に受け取ることで、作成したAccess RoleのFunctional RoleへのGRANTもまとめて行う
  - `manager_ar_to_fr_set`
  - `transformer_ar_to_fr_set`
  - `read_only_ar_to_fr_set`
  - `etl_tool_ar_to_fr_set`
- 作成したAccess RoleはSYSADMINにもGRANTすることで、SYSADMINが全てのオブジェクトにアクセスできるようにする

- **CODE**

    ```toml
    # ウェアハウスの作成
    resource "snowflake_warehouse" "this" {
      name           = var.warehouse_name
      comment        = var.comment
      warehouse_size = var.warehouse_size
    
      auto_resume                         = var.auto_resume
      auto_suspend                        = var.auto_suspend
      enable_query_acceleration           = var.enable_query_acceleration
      initially_suspended                 = var.initially_suspended
      max_cluster_count                   = var.max_cluster_count
      max_concurrency_level               = var.max_concurrency_level
      min_cluster_count                   = var.min_cluster_count
      query_acceleration_max_scale_factor = var.query_acceleration_max_scale_factor
      resource_monitor                    = var.resource_monitor
      scaling_policy                      = var.scaling_policy
      statement_queued_timeout_in_seconds = var.statement_queued_timeout_in_seconds
      statement_timeout_in_seconds        = var.statement_timeout_in_seconds
      warehouse_type                      = var.warehouse_type
    }
    
    # 対象のウェアハウスに対するUSAGEのAccess Roleを作成
    resource "snowflake_role" "usage_ar" {
      name    = "_WAREHOUSE_${snowflake_warehouse.this.name}_USAGE_AR"
      comment = "USAGE role of ${snowflake_warehouse.this.name}"
    
      depends_on = [snowflake_warehouse.this]
    }
    
    # USAGEのAccess Roleへの権限のgrant
    resource "snowflake_grant_privileges_to_account_role" "grant_usage" {
      privileges        = ["USAGE", "MONITOR"]
      account_role_name = snowflake_role.usage_ar.name
      on_account_object {
        object_type = "WAREHOUSE"
        object_name = snowflake_warehouse.this.name
      }
    
      depends_on = [snowflake_role.usage_ar]
    }
    
    # Functional RoleにUSAGEのAccess Roleをgrant
    resource "snowflake_grant_account_role" "grant_usage_ar_to_fr" {
      for_each = var.grant_usage_ar_to_fr_set
    
      role_name        = snowflake_role.usage_ar.name
      parent_role_name = each.value
    
      depends_on = [snowflake_role.usage_ar]
    }
    
    # 対象のウェアハウスに対するADMINのAccess Roleを作成
    resource "snowflake_role" "admin_ar" {
      name    = "_WAREHOUSE_${snowflake_warehouse.this.name}_ADMIN_AR"
      comment = "ADMIN role of ${snowflake_warehouse.this.name}"
    
      depends_on = [snowflake_warehouse.this]
    }
    
    # ADMINのAccess Roleへの権限のgrant
    resource "snowflake_grant_privileges_to_account_role" "grant_admin" {
      all_privileges    = true
      account_role_name = snowflake_role.admin_ar.name
      on_account_object {
        object_type = "WAREHOUSE"
        object_name = snowflake_warehouse.this.name
      }
    
      depends_on = [snowflake_role.admin_ar]
    }
    
    # Functional RoleにADMINのAccess Roleをgrant
    resource "snowflake_grant_account_role" "grant_admin_ar_to_fr" {
      for_each = var.grant_admin_ar_to_fr_set
    
      role_name        = snowflake_role.admin_ar.name
      parent_role_name = each.value
    
      depends_on = [snowflake_role.admin_ar]
    }
    
    # SYSADMINにAccess Roleをgrant
    resource "snowflake_grant_account_role" "grant_to_sysadmin" {
      for_each         = toset([snowflake_role.usage_ar.name, snowflake_role.admin_ar.name])
      role_name        = each.value
      parent_role_name = "SYSADMIN"
    
      depends_on = [snowflake_role.usage_ar, snowflake_role.admin_ar]
    }
    ```
  
## **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**だけoutputとして定義しています。

- **CODE**
  
    ```toml
    output "name" {
      description = "Name of the warehouse."
      value       = snowflake_warehouse.this.name
    }
    ```

## **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`snowflake_warehouse`**リソースで使う値を定義しています。
- Access Roleを付与したいFunctional RoleをModule使用時に受け取るために下記も定義しています。
  - `manager_ar_to_fr_set`
  - `transformer_ar_to_fr_set`
  - `etl_tool_ar_to_fr_set`
  - `read_only_ar_to_fr_set`

- **CODE**

    ```toml
    variable "warehouse_name" {
      description = "Name of the warehouse"
      type        = string
      default     = null
    }
    
    variable "auto_resume" {
      description = "Specifies whether to automatically resume a warehouse when a SQL statement (e.g. query) is submitted to it."
      type        = bool
      default     = true
    }
    
    variable "auto_suspend" {
      description = "Specifies the number of seconds of inactivity after which a warehouse is automatically suspended."
      type        = number
      default     = 60
    }
    
    variable "comment" {
      description = "Write description for the schema"
      type        = string
      default     = null
    }
    
    variable "enable_query_acceleration" {
      description = "Specifies whether to enable the query acceleration service for queries that rely on this warehouse for compute resources."
      type        = bool
      default     = null
    }
    
    variable "initially_suspended" {
      description = "Specifies whether the warehouse is created initially in the Suspended state."
      type        = bool
      default     = true
    }
    
    variable "max_cluster_count" {
      description = "Specifies the maximum number of server clusters for the warehouse."
      type        = number
      default     = 1
    }
    
    variable "max_concurrency_level" {
      description = "Object parameter that specifies the concurrency level for SQL statements (i.e. queries and DML) executed by a warehouse."
      type        = number
      default     = null
    }
    
    variable "min_cluster_count" {
      description = "Specifies the minimum number of server clusters for the warehouse (only applies to multi-cluster warehouses)."
      type        = number
      default     = 1
    }
    
    variable "query_acceleration_max_scale_factor" {
      description = "Specifies the maximum scale factor for leasing compute resources for query acceleration. The scale factor is used as a multiplier based on warehouse size."
      type        = number
      default     = null
    }
    
    variable "resource_monitor" {
      description = "Specifies the name of a resource monitor that is explicitly assigned to the warehouse."
      type        = string
      default     = null
    }
    
    variable "scaling_policy" {
      description = "Specifies the policy for automatically starting and shutting down clusters in a multi-cluster warehouse running in Auto-scale mode."
      type        = string
      default     = null
    }
    
    variable "statement_queued_timeout_in_seconds" {
      description = "Object parameter that specifies the time, in seconds, a SQL statement (query, DDL, DML, etc.) can be queued on a warehouse before it is canceled by the system."
      type        = number
      default     = null
    }
    
    variable "statement_timeout_in_seconds" {
      description = "Specifies the time, in seconds, after which a running SQL statement (query, DDL, DML, etc.) is canceled by the system"
      type        = number
      default     = 3600
    }
    
    variable "warehouse_size" {
      description = "Specifies the size of the virtual warehouse. "
      type        = string
      default     = "XSMALL"
    }
    
    variable "warehouse_type" {
      description = "Specifies a STANDARD or SNOWPARK-OPTIMIZED warehouse"
      type        = string
      default     = "STANDARD"
    }
    
    variable "grant_usage_ar_to_fr_set" {
      description = "Set of functional role for grant usage access role"
      type        = set(string)
      default     = []
    }
    
    variable "grant_admin_ar_to_fr_set" {
      description = "Set of functional role for grant admin access role"
      type        = set(string)
      default     = []
    }
    
    ```
