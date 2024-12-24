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
  - [main.tf](../../../terraform/snowflake/modules/access_role_and_database/main.tf)

## **outputs.tf**

他のModuleから作成したデータベース名を参照できるように、**`name`**だけoutputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/access_role_and_database/outputs.tf)

## **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`snowflake_database`**リソースで使う値を定義しています。
- Access Roleを付与したいFunctional RoleをModule使用時に受け取るために下記も定義しています。
  - `manager_ar_to_fr_set`
  - `transformer_ar_to_fr_set`
  - `etl_tool_ar_to_fr_set`
  - `read_only_ar_to_fr_set`

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/access_role_and_database/variables.tf)

## **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/access_role_and_database/versions.tf)
