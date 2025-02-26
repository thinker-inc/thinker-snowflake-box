# 概要

- 「Functional Roleを作成するリソース」と「作成したFunctional Roleを各ユーザーにGRANTするリソース」をModuleとして定義しています。

## 各種ファイル

### main.tf

各種リソースをまとめて定義しています。

- Functional Roleの作成だけでなく、ユーザーへのGRANTも行う。GRANT先のユーザーリストは`grant_usage_ar_to_fr_set`で受け取る
- Functional RoleはSYSADMINにもGRANTすることで、SYSADMINが全てのFunctional Roleの親となるようにする

- **CODE**
  - [main.tf](../../../terraform/snowflake/modules/functional_role/main.tf)

### **outputs.tf**

- 他のModuleから作成したFunctional Role名を参照できるように、**`name`**だけoutputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/functional_role/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`snowflake_role`**リソースで使う値を定義しています。
- Functionalを付与したいユーザーをModule使用時に受け取るために**`grant_user_set`**も定義しています。

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/functional_role/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
  - **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/functional_role/versions.tf)
