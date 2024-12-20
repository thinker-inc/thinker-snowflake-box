# 概要

Snowflakeのアカウントを複数定義することが可能です。下記例です。

- main - 基本的に使用するメインアカウント
- stg - staging環境
  - main環境に適用する前にstg環境に適用し、確認などを実施します。(任意)
- "_"が付いてるファイルは部品化されたファイルです。

## ディレクトリ構成

```text
.
└── terraform/
    ├── snowflake
    └── accounts/
        ├── main/
        │   ├── definitions/
        │   │   └── users.yml
        │   ├── _data_lake
        │   ├── _dwh
        │   ├── _mart
        │   ├── _security
        │   ├── _satging
        │   ├── _storage_integration
        │   ├── _workspace
        │   ├── authentication_policy
        │   ├── backend
        │   ├── locals
        │   ├── main
        │   ├── outputs
        │   ├── security
        │   ├── variables
        │   └── versions
        └── modules/
            ├── access_role_and_database/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── access_role_and_schema/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── access_role_and_database/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── access_role_and_warehouse/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── authencation_policy/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── file_format/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── functional_role/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── grant_on_account/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── network_policy/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── network_rule/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── password_policy/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── service_user/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            ├── stage/
            │   ├── main.tf
            │   ├── outputs.tf
            │   ├── variables.tf
            │   └── versions.tf
            └── storage_integration/
                ├── main.tf
                ├── outputs.tf
                ├── variables.tf
                └── versions.tf
            
```
