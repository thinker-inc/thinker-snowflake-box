# 概要

- ネットワークポリシーを使用して、Snowflakeサービスおよび内部ステージへのインバウンドアクセス機能をModuleとして定義しています。
- ・ネットワークポリシーの許可リストは、Snowflakeサービスまたは内部ステージへのアクセスを許可するアクセスを制御し、 ブロックリストは明示的にブロックするリクエストを制御する

## 各種ファイル

### main.tf

各種リソースをまとめて定義しています。

- ネットワークポリシーを作成
  - ネットワークルールのリストを受け取り、それをネットワークポリシーに適用
- アカウントもしくはユーザーにネットワークポリシーを取り付ける

- **CODE**
  - [main.tf](../../../terraform/snowflake/modules/network_policy/main.tf)

### **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**と**`fully_qualified_name`**outputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/network_policy/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`network_policy`**リソースで使う値を定義しています。

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/network_policy/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/network_policy/versions.tf)
