# 概要

- 認証ポリシー「account」、「user」、「service user」をModuleとして定義しています。

## 各種ファイル

### main.tf

各種リソースをまとめて定義しています。

- 認証ポリシー (authentication_policy) を作成
- アカウント単位でポリシーを取り付ける
- ユーザー単位でポリシー取り付ける

- **CODE**
  - [main.tf](../../../terraform/snowflake/modules/authentication_policy/main.tf)

### **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**だけoutputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/authentication_policy/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`authentication_policy`**リソースで使う値を定義しています。

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/authentication_policy/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/authentication_policy/versions.tf)
