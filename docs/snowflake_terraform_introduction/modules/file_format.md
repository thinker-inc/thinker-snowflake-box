# 概要

- 元データ（ファイル）の形式を予め定義しておく機能をModuleとして定義しています。

## 各種ファイル

### main.tf

各種リソースをまとめて定義しています。

- ファイルフォーマット （file_format） を作成
- ファイルフォーマット何の操作権限を何のロールに付与

- **CODE**
  - [main.tf](../../../terraform/snowflake/modules/file_format/main.tf)

### **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**と**`fully_qualified_name`**outputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/file_format/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`file_format`**リソースで使う値を定義しています。

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/file_format/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/file_format/versions.tf)
