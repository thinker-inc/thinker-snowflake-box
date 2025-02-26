# 概要

- 「ウェアハウスを作成するリソース」と「作成するウェアハウスに関連するAccess Roleのリソース」をModuleとして定義しています。

## 各種ファイル

### main.tf

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
  - [main.tf](../../../terraform/snowflake/modules/access_role_and_warehouse/main.tf)

### **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**だけoutputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/access_role_and_warehouse/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`snowflake_warehouse`**リソースで使う値を定義しています。
- Access Roleを付与したいFunctional RoleをModule使用時に受け取るために下記も定義しています。
  - `manager_ar_to_fr_set`
  - `transformer_ar_to_fr_set`
  - `etl_tool_ar_to_fr_set`
  - `read_only_ar_to_fr_set`

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/access_role_and_warehouse/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/access_role_and_warehouse/versions.tf)
