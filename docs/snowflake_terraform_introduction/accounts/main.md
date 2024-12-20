# 概要

Snowflakeのアカウントごとにフォルダを用意し配下に、次章以降のファイルを定義します。

## 説明

### **backend.tf**

- Remote Stateを管理するS3とDynamoDBを定義しています。
- **CODE**

    ```toml
    terraform {
      backend "s3" {
        bucket       = "terraform-state-thinker-snowflake-standard"
        key          = "terraform/resource/snowflake.tfstate"
        encrypt      = "true"
        region       = "ap-northeast-1"
        use_lockfile = true
      }
    }
    ```

### **outputs.tf**

- 必須となるoutputがなかったため、特にコードを書いていません。
- いつか使うときのためにファイルだけ作成しています。

### **variables.tf**

- 必須となるvariableがなかったため、特にコードを書いていません。
- いつか使うときのためにファイルだけ作成しています。

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定と、各aliasの定義をしています。
- 特徴としては、SYSADMINとSECURITYADMINをGRANTした**`TERRAFORM`**というロールを作成し、
基本的にはこのaliasを用いてTerraformを実行しています。
- **CODE**

    ```toml
    terraform {
      required_providers {
        snowflake = {
          source  = "Snowflake-Labs/snowflake"
          version = "~> 0.91.0"
        }
      }
    }
    
    # 事前にSYSADMINとSECURITYADMINをGRANTしたロール。
    provider "snowflake" {
      alias = "terraform"
      role  = "TERRAFORM"
    }
    
    provider "snowflake" {
      alias = "sys_admin"
      role  = "SYSADMIN"
    }
    
    provider "snowflake" {
      alias = "security_admin"
      role  = "SECURITYADMIN"
    }
    ```

### locals.tf

- `/accounts/main/definitions/users.yml`に定義されているユーザーのリストを作成します。
- `initial_user_password`は、各ユーザーの初期パスワードの設定値となります。
  - ※初期ログイン時に、パスワード変更されることを前提としています。
- **CODE**

    ```toml
    locals {
      # Snowflake Users
      initial_user_password = "2tK4Z@fZAwkjqzDZbZTh"
      _users_yml            = yamldecode(file("${path.root}/definitions/users.yml"))
      users                 = local._users_yml["users"] != null ? local._users_yml["users"] : []
    }
    ```

### **main.tf**

定義した各Moduleを使用し、Snowflakeでの各オブジェクトを定義していくファイルとなっています。

※DBとSchemaに紐づくオブジェクトは定義しない

- 各Moduleの使い方のポイントを記載します。
- 各Moduleで定義したオブジェクトのGRANT先のリストを格納する下記変数に対しては、関連するModuleのOutputを指定すること
  - このように記述しないと、Module間の依存関係がうまく構築できず、terraform apply時にエラーとなります
  - `grant_user_set`
  - `grant_usage_ar_to_fr_set`
  - `grant_admin_ar_to_fr_set`
- このコードではModule使用時に、各Moduleで定義した`variable`全てに対して値を入れていません。
各Moduleの**`variables.tf`**で定義したvariableの**`default`**の値を確認の上、必要な場合にはModule使用時に該当するvariableに値を入れてください
- システム以外のユーザーは`/accounts/main/definitions/users.yml`に定義してください
  - 初期値は、設定したいvariablesによって、更新してください。

- **CODE - main.tf**

    ```toml
    ########################
    # USER
    ########################
    # ./definitions/users.tf
    module "users" {
      source = "../../modules/user"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      for_each = {
        for key, user in local.users : user.name => user
      }
    
      name     = each.value.name
      comment  = each.value.comment
      password = local.initial_user_password
    }
    
    module "etl_tool_user" {
      source = "../../modules/user"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      name    = "ETL_USER"
      comment = "ETL tool user was created by terraform"
    }
    
    module "bi_tool_user" {
      source = "../../modules/user"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      name    = "BI_USER"
      comment = "BI tool user was created by terraform"
    }
    
    ########################
    # Functional Role
    ########################
    module "fr_manager" {
      depends_on = [module.users]
      source     = "../../modules/functional_role"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      role_name = "FR_MANAGER"
      grant_user_set = [
        "RYOTA_HASEGAWA"
      ]
      comment = "Functional Role for Admin in Project all"
    }
    
    module "fr_data_engineer" {
      depends_on = [module.users]
      source     = "../../modules/functional_role"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      role_name = "FR_DATA_ENGINEER"
      grant_user_set = [
        "RYOTA_HASEGAWA",
        "ENGINEER_HASEGAWA",
      ]
      comment = "Functional Role for Data Engineer in Project all"
    }
    
    module "fr_scientist" {
      depends_on = [module.users]
      source     = "../../modules/functional_role"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      role_name = "FR_SCIENTIST"
      grant_user_set = [
        "RYOTA_HASEGAWA",
        "SCIENTIST_HASEGAWA",
      ]
      comment = "Functional Role for data scientist in Project {}"
    }
    
    module "fr_analyst" {
      depends_on = [module.users]
      source     = "../../modules/functional_role"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      role_name = "FR_ANALYST"
      grant_user_set = [
        "RYOTA_HASEGAWA",
        "ANALYST_HASEGAWA",
      ]
      comment = "Functional Role for analysis in Project {}"
    }
    
    module "fr_bi_tool" {
      depends_on = [module.users, module.bi_tool_user]
      source     = "../../modules/functional_role"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      role_name = "FR_BI_TOOL"
      grant_user_set = [
        "RYOTA_HASEGAWA",
        module.bi_tool_user.name
      ]
      comment = "Functional Role for business intelligence in Project {}"
    }
    
    module "fr_etl_tool_import" {
      depends_on = [module.users, module.etl_tool_user]
      source     = "../../modules/functional_role"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      role_name = "FR_ETL_TOOL_IMPORT"
      grant_user_set = [
        "RYOTA_HASEGAWA",
        module.etl_tool_user.name
      ]
      comment = "Functional Role for etl tools import in Project {}"
    }
    
    module "fr_etl_tool_transform" {
      depends_on = [module.users, module.etl_tool_user]
      source     = "../../modules/functional_role"
      providers = {
        snowflake = snowflake.security_admin
      }
    
      role_name = "FR_ETL_TRANSFORM"
      grant_user_set = [
        "RYOTA_HASEGAWA",
        module.etl_tool_user.name
      ]
      comment = "Functional Role for etl tools transform in Project {}"
    }
    
    ########################
    # Warehouse
    ########################
    module "manager_wh" {
      source = "../../modules/access_role_and_warehouse"
      providers = {
        snowflake = snowflake.terraform
      }
    
      warehouse_name = "MANAGER_WH"
      warehouse_size = "XSMALL"
      comment        = "Warehouse for manager of {} projects"
    
      grant_usage_ar_to_fr_set = [
      ]
      grant_admin_ar_to_fr_set = [
        module.fr_manager.name
      ]
    }
    
    module "transformer_wh" {
      source = "../../modules/access_role_and_warehouse"
      providers = {
        snowflake = snowflake.terraform
      }
    
      warehouse_name = "TRANSFORMER_WH"
      warehouse_size = "XSMALL"
      comment        = "Warehouse for Transformer of {} projects"
    
      grant_usage_ar_to_fr_set = [
        module.fr_data_engineer.name,
        module.fr_scientist.name
      ]
      grant_admin_ar_to_fr_set = [
        module.fr_manager.name
      ]
    }
    
    module "read_only_wh" {
      source = "../../modules/access_role_and_warehouse"
      providers = {
        snowflake = snowflake.terraform
      }
    
      warehouse_name = "READ_ONLY_WH"
      warehouse_size = "XSMALL"
      comment        = "Warehouse for Read Only of {} projects"
    
      grant_usage_ar_to_fr_set = [
        module.fr_analyst.name
      ]
      grant_admin_ar_to_fr_set = [
        module.fr_manager.name
      ]
    }
    
    module "etl_tool_import_wh" {
      source = "../../modules/access_role_and_warehouse"
      providers = {
        snowflake = snowflake.terraform
      }
    
      warehouse_name = "ETL_IMPORT_WH"
      warehouse_size = "XSMALL"
      comment        = "Warehouse for ETL IMPORT of {} projects"
    
      grant_usage_ar_to_fr_set = [
        module.fr_etl_tool_import.name
      ]
      grant_admin_ar_to_fr_set = [
        module.fr_manager.name
      ]
    }
    
    module "etl_tool_transform_wh" {
      source = "../../modules/access_role_and_warehouse"
      providers = {
        snowflake = snowflake.terraform
      }
    
      warehouse_name = "ETL_TRANSFORM_WH"
      warehouse_size = "XSMALL"
      comment        = "Warehouse for ETL TRANSFORM of {} projects"
    
      grant_usage_ar_to_fr_set = [
        module.fr_etl_tool_transform.name
      ]
      grant_admin_ar_to_fr_set = [
        module.fr_manager.name
      ]
    }
    
    ```

- **CODE - user.yml**

    ```yaml
    ########################
    # FORMAT: YAML
    # Description: Snowflake users definition file
    #   - name: USER_NAME # 一意な名前
    #     comment: description was created by terraform # コメント
    ########################
    users:
      # - name: RYOTA_HASEGAWA
      #   comment: Account owner hasegawa
      - name: ENGINEER_HASEGAWA
        comment: Engineer hasegawa was created by terraform
      - name: ANALYST_HASEGAWA
        comment: Analyst hasegawa was created by terraform
      - name: SCIENTIST_HASEGAWA
        comment: Scientist hasegawa was created by terraform
    ```

## _{database | domain}.tf

定義した各Moduleを使用し、Snowflakeでの`DB`と`Schema`に紐づく各オブジェクトを定義していくファイルとなっています。

必ずファイル名には、前方Prefixとしてアンダーバー(`_`)を定義します。

- 各Moduleで定義したオブジェクトのGRANT先のリストを格納する下記変数に対しては、関連するModuleのOutputを指定すること
  - このように記述しないと、Module間の依存関係がうまく構築できず、terraform apply時にエラーとなります
  - `manager_ar_to_fr_set`
  - `transformer_ar_to_fr_set`
  - `read_only_ar_to_fr_set`
  - `etl_tool_ar_to_fr_set`

- **CODE - _{domain}.tf**

    ```toml
    ########################
    # Database
    ########################
    module "data_lake_db" {
      source = "../../modules/access_role_and_database"
      providers = {
        snowflake = snowflake.terraform
      }
    
      database_name               = "DATA_LAKE"
      comment                     = "Database to store loaded raw data"
      data_retention_time_in_days = 1
    
      manager_ar_to_fr_set = [
        module.fr_manager.name
      ]
    
      transformer_ar_to_fr_set = [
        module.fr_data_engineer.name,
        module.fr_scientist.name
      ]
    
      read_only_ar_to_fr_set = [
        module.fr_analyst.name
      ]
    
      etl_tool_ar_to_fr_set = [
        module.fr_etl_tool_import.name
      ]
    }
    
    ########################
    # Schema
    ########################
    module "data_lake_db_service_a_schema" {
      source = "../../modules/access_role_and_schema"
      providers = {
        snowflake = snowflake.terraform
      }
    
      schema_name         = "SERVICE_A"
      database_name       = module.data_lake_db.name
      comment             = "Schema to store loaded raw data of service A"
      data_retention_days = 1
    
      manager_ar_to_fr_set = [
        module.fr_manager.name
      ]
    
      transformer_ar_to_fr_set = [
      ]
    
      read_only_ar_to_fr_set = [
        module.fr_data_engineer.name,
        module.fr_scientist.name,
        module.fr_analyst.name
      ]
    
      etl_tool_ar_to_fr_set = [
        module.fr_etl_tool_import.name
      ]
    }
    
    module "data_lake_db_service_b_schema" {
      source = "../../modules/access_role_and_schema"
      providers = {
        snowflake = snowflake.terraform
      }
    
      schema_name         = "SERVICE_B"
      database_name       = module.data_lake_db.name
      comment             = "Schema to store loaded raw data of service B"
      data_retention_days = 1
    
      manager_ar_to_fr_set = [
        module.fr_manager.name
      ]
    
      transformer_ar_to_fr_set = [
      ]
    
      read_only_ar_to_fr_set = [
        module.fr_data_engineer.name,
        module.fr_analyst.name,
        module.fr_scientist.name
      ]
    
      etl_tool_ar_to_fr_set = [
        module.fr_etl_tool_import.name
      ]
    }
    
    ```
