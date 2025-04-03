# リソース名を変更する方法

リソース名を直接変えるとな、既存のリソースを削除して新しいリソースを作成することになります。そのため、リソース名を変更する場合は、以下の手順で行います。

## S3に保存させているremote stateをlocalにpull

```
$ cd terraform/snowflake/accounts/main
$ terraform state pull > terraform.tfstate
$ terraform state list
```

## local stateの移動

`-state=terraform.tfstate`で、local stateで処理する

### -dry-runで確認

```
$ terraform state mv -state=terraform.tfstate -dry-run module.data_lake_db_service_a_schema module.data_lake_db_service_ga4_schema
```

### 実行

```
$ terraform state mv -state=terraform.tfstate module.data_lake_db_service_a_schema module.data_lake_db_service_ga4_schema
```

### 結果確認

```
root@fafb9011639e:/usr/src/terraform/snowflake/accounts/main# terraform state mv -state=local.tfstate module.data_lake_db_service_a_schema module.data_lake_db_service_ga4_schema
Move "module.data_lake_db_service_a_schema" to "module.data_lake_db_service_ga4_schema"
Successfully moved 1 object(s).
```

## backend.tfの設定をローカルに向ける

```
terraform {
  # backend "s3" {
  #   bucket       = "terraform-state-thinker-snowflake-standard"
  #   key          = "terraform/resource/snowflake.tfstate"
  #   encrypt      = "true"
  #   region       = "ap-northeast-1"
  #   use_lockfile = true
  # }

  backend "local" {
    path = "local.tfstate"
  }
}
```

### local用に初期化

remote stateをlocal stateに変更するために、初期化を行います。

```
$ terraform init --reconfigure
```

実行結果

```
Successfully configured the backend "local"! Terraform will automatically
use this backend unless the backend configuration changes.
```

## 動作確認

```
$ terraform plan
```

実行結果
  
```
No changes. Your infrastructure matches the configuration.
```

## local stateをremote stateにpush

```
$ terraform state push terraform.tfstate
```

## backend.tfの設定をリモートに向ける

```
terraform {
  backend "s3" {
    bucket       = "terraform-state-thinker-snowflake-standard"
    key          = "terraform/resource/snowflake.tfstate"
    encrypt      = "true"
    region       = "ap-northeast-1"
    use_lockfile = true
  }

  # backend "local" {
  #   path = "local.tfstate"
  # }
}
```

### remote用に初期化

local stateをremote stateに変更するために、初期化を行います。

```
$ terraform init --reconfigure
```

### planして変更確認

```
$ terraform plan
```

実行結果

```
No changes. Your infrastructure matches the configuration.
```
