# 概要

- 「最低８文字以上」「大文字小文字をそれぞれ１文字以上含めること」みたいな制約のもとにパスワードを設定するように指示をModuleとして定義しています。
  - 企業のポリシーに合わせてパスワードポリシーを設定することができます。

## 各種ファイル

### main.tf

各種リソースをまとめて定義しています。

- 新しいパスワードポリシーを作成するか、既存のパスワードポリシーを置き換えます。
  - パスワード最低何文字以上か
  - 最短何月間パスワードを変更しないといけないか
- 作成されたパスワードポリシーをアカウントまたはユーザーに取り付けます。

- **CODE**
  - [main.tf](../../../terraform/snowflake/modules/password_policy/main.tf)

### **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**と**`fully_qualified_name`**outputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/password_policy/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`password_policy`**リソースで使う値を定義しています。

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/password_policy/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/password_policy/versions.tf)
