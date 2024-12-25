# 概要

- ネットワーク識別子を論理単位にグループ化するスキーマレベルのオブジェクトをModuleとして定義しています。
- ネットワークルール作成によってアクセスの許可/拒否は設定されません。
  - ネットワークポリシーでアクセスの許可/拒否を設定します。
- 論理的な分割ができるので、あるとIPアドレスの管理がしやすいです。

## 各種ファイル

### main.tf

各種リソースをまとめて定義しています。

- ネットワークルールを作成
  - IPv4 アドレス。Snowflakeはクラスレスドメイン間ルーティング（CIDR）表記を使用したIPアドレスの範囲をサポートしています。
    - 例
      - 192.168.1.0/24
      - 192.168.1.0

- **CODE**
  - [main.tf](../../../terraform/snowflake/modules/network_rule/main.tf)

### **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**と**`fully_qualified_name`**outputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/network_rule/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`network_policy`**リソースで使う値を定義しています。

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/network_rule/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/network_rule/versions.tf)
