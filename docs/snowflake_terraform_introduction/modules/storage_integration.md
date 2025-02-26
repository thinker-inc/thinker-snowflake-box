# 概要

- S3等のクラウドストレージにアクセスするオブジェクト「ストレージ統合」をModuleとして定義しています。
- ストレージ統合は、外部クラウドストレージ用に生成されたIDおよびアクセス管理（IAM）エンティティを、許可またはブロックされたストレージの場所（Amazon S3、Google Cloud Storage、またはMicrosoft Azure）のオプションセットとともに格納するSnowflakeオブジェクトです。

## 各種ファイル

### main.tf

各種リソースをまとめて定義しています。

- ストレージ統合の作成
- ストレージ統合に何の操作権限を何のロールに付与

- **CODE**
  - [main.tf](../../../terraform/snowflake/modules/storage_integration/main.tf)

### **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**と**`fully_qualified_name`**outputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/storage_integration/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`stage`**リソースで使う値を定義しています。

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/storage_integration/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/storage_integration/versions.tf)
