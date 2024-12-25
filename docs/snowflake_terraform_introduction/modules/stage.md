# 概要

- データファイルをテーブルにロードできるように、データファイルが保存されている場所（いわゆる「ステージングされた場所」）をModuleとして定義しています。

## 各種ファイル

### main.tf

各種リソースをまとめて定義しています。

- ステージの作成
- ステージに何の操作権限を何のロールに付与

- **CODE**
  - [main.tf](../../../terraform/snowflake/modules/stage/main.tf)

### **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**と**`fully_qualified_name`**outputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/stage/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`stage`**リソースで使う値を定義しています。

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/stage/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/stage/versions.tf)
