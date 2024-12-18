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