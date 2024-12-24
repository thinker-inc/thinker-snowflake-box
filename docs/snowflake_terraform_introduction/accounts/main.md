# 概要

Snowflakeのアカウントごとにフォルダを用意し配下に、次章以降のファイルを定義します。

## 説明

### **backend.tf**

- Remote Stateを管理するS3を定義しています。
- **CODE**
  - [backend.tf](../../../terraform/snowflake/accounts/main/backend.tf)

### **outputs.tf**

- 必須となるoutputがなかったため、特にコードを書いていません。
- いつか使うときのためにファイルだけ作成しています。
- **CODE**
  - [outputs.tf](../../../terraform/snowflake/accounts/main/outputs.tf)

### **variables.tf**

- 必須となるvariableがなかったため、特にコードを書いていません。
- いつか使うときのためにファイルだけ作成しています。
- **CODE**
  - [variables.tf](../../../terraform/snowflake/accounts/main/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定と、各aliasの定義をしています。
- 特徴としては、SNOWFLAKE SQLでSYSADMINとSECURITYADMINをGRANTした**`TERRAFORM`**と**`fr_security_manager`**ロールを作成し、基本的にはこのaliasを用いてTerraformを実行しています。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/accounts/main/versions.tf)

### locals.tf

- 定義されているユーザーグループのリストを作成します。
- マネージャーグループ以外のユーザーグループは、マネージャーグループとユーザー名を組み合わせます
- **CODE**
  - [locals.tf](../../../terraform/snowflake/accounts/main/locals.tf)

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
- **CODE**
  - [main.tf](../../../terraform/snowflake/accounts/main/main.tf)

## _{database | domain}.tf

定義した各Moduleを使用し、Snowflakeでの`DB`と`Schema`に紐づく各オブジェクトを定義していくファイルとなっています。

必ずファイル名には、前方Prefixとしてアンダーバー(`_`)を定義します。
※databaseの場合は、前方Prefixとして(`_db_`)を定義します。

- 各Moduleで定義したオブジェクトのGRANT先のリストを格納する下記変数に対しては、関連するModuleのOutputを指定すること
  - このように記述しないと、Module間の依存関係がうまく構築できず、`terraform apply`時にエラーとなります
    - `manager_ar_to_fr_set`  
    - `transformer_ar_to_fr_set`
    - `read_only_ar_to_fr_set`
    - `etl_tool_ar_to_fr_set`

- **CODE**
  - [database.tf](../../../terraform/snowflake/accounts/main/_db_data_lake.tf)
