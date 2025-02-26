# 概要

Snowflakeのアカウントを複数定義することが可能です。下記例です。

- main - 基本的に使用するメインアカウント
- stg - staging環境
  - main環境に適用する前にstg環境に適用し、確認などを実施します。(任意)
- "_"が付いてるファイルは部品化されたファイルです。

## ディレクトリ構成

各modulesフォルダの配下には、同一のファイル構成が存在しています。

- main.tf
- outputs.tf
- variables.tf
- versions.tf

### 構成図

```text
.
└── terraform/
    ├── snowflake
    └── accounts/
        ├── main/
        │   ├── _db_data_lake
        │   ├── _db_dwh
        │   ├── _db_mart
        │   ├── _db_security
        │   ├── _db_satging
        │   ├── _db_workspace
        │   ├── _db_authentication_policy
        │   ├── _storage_integration
        │   ├── backend
        │   ├── locals
        │   ├── main
        │   ├── outputs
        │   ├── security
        │   ├── variables
        │   └── versions
        └── modules/
            ├── access_role_and_database/
            ├── access_role_and_schema/
            ├── access_role_and_database/
            ├── access_role_and_warehouse/
            ├── authencation_policy/
            ├── file_format/
            ├── functional_role/
            ├── network_policy/
            ├── network_rule/
            ├── password_policy/
            ├── service_user/
            ├── stage/
            └── storage_integration/
            
```
