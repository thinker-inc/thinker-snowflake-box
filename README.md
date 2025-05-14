# Snowflake Terraform Template

## 概要

- SnowflakeをTerraformで構築するためのテンプレートです。

## SNOWFLAKE環境初期設定

- SNOWFLAKE環境にアカウントアドミンとしてログインされてから下記のSQLを実施してください
  - [snowflake_init.sql](./snowflakesql/environment/snowflake_init.sql)
  - [terraform_init.sql](./snowflakesql/environment/terraform_init.sql)

## Terraform実行

- 詳細の手順は、[terraform_dev.md](./docs/terraform_dev.md) を参照してください。
- Terraformの接続には、秘密鍵を利用します。秘密鍵の生成方法は、[snowflake_key_pair.md](./docs/snowflake_key_pair.md) を参照してください。

## snowflake-labs から snowflakedb に移行したことについて

- v2.0.0への移行に伴い、snowflake-labs から snowflakedb に移行しました。
  - providerのsourceが変更になりました。
  - state file が変更になりました。
    - [Upgrading from Snowflake-Labs to snowflakedb Terraform Registry namespace](https://github.com/snowflakedb/terraform-provider-snowflake/blob/main/SNOWFLAKEDB_MIGRATION.md) を参照してください。
