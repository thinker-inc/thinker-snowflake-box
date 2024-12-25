# 概要

- troccoやtableau cloudなどのSnowflake外のサービスからの認証や、自社製のアプリからの認証に使用するユーザーをModuleとして定義しています。
- 一般ユーザーとは異なり、以下のような特徴があります。
  - パスワードやSAML SSOを用いて、ログインが不可能となる
  - MFAの設定も不可能であり、authentication policyによるMFAの強制からも除外される
  - FIRST_NAME、MIDDLE_NAME、LAST_NAME、PASSWORD、MUST_CHANGE_PASSWORD、MINS_TO_BYPASS_MFAの設定が不可能

## 各種ファイル

### main.tf

各種リソースをまとめて定義しています。

- 新しいサービスユーザーを作成するために必要な情報を定義しています。

- **CODE**
  - [main.tf](../../../terraform/snowflake/modules/service_user/main.tf)

### **outputs.tf**

- 他のModuleから作成したウェアハウス名を参照できるように、**`name`**だけoutputとして定義しています。

- **CODE**
  - [outputs.tf](../../../terraform/snowflake/modules/service_user/outputs.tf)

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`service_user`**リソースで使う値を定義しています。

- **CODE**
  - [variables.tf](../../../terraform/snowflake/modules/service_user/variables.tf)

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。
- **CODE**
  - [versions.tf](../../../terraform/snowflake/modules/service_user/versions.tf)
