# modules 構成図

## 概要

```plaintext
.
└── {module_folder}/
    ├── main.tf
    ├── output.tf
    ├── variables.tf
    └── outputs.tf
```

## 説明

### **main.tf**

- 各種リソースをまとめて定義しています。

### **output.tf**

- 他のModuleから作成したデータベース名を参照できるように、基本**`name`**だけoutputとして定義しています。

### **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。

### **versions.tf**

- 使用するSnowflakeのterraform providerのバージョン指定します。

## modules 一覧

```plaintext
- access_role_and_database
- access_role_and_schema
- access_role_and_warehouse
- authentication_policy
- file_format
- functional_role
- network_policy
- network_rule
- password_policy
- service_user
- stage
- storage_integration
```

- 各moduleの中、`main.tf`, `output.tf`, `variables.tf`, `versions.tf`が存在します。
