# Terraform Template

## Terraform State

AWS S3とDynamoDBを利用したTerraformのState管理を行う

## Snowflake Terraform - Local

ローカルで Snowflake を実行するための手順を記載

### 前提

- VSCode
- Docker
- docker-compose
- aws - thinker-snowflake
  - ユーザーの権限を持っていること

### 0. Docker のビルド前に設定すること

- .env.localファイルを作成します。
  - snowflakeの情報を設定します。
  - 各項目の設定値については、管理者に問い合わせてください。

```ini
SNOWFLAKE_AUTHENTICATOR=JWT
SNOWFLAKE_ACCOUNT=thinker-terraform_template
SNOWFLAKE_USER=TERRAFORM_USER
SNOWFLAKE_PRIVATE_KEY=""
AWS_PROFILE=thinker-snowflake-terraform
```

- AWS_PROFILE
  - `backend.tf`のstateをS3に指定している場合は、AWSのプロファイル名を指定する

### 1. コンテナにアクセスする

AWS profile の設定を行う
※既に設定済の場合はスキップ可能

```bash
code ~/.aws/config
```

thinker-snowflake 用のAWSプロファイルを設定する。

![Alt text](./docs/img/image.png)

```conf
[profile thinker-snowflake-terraform]
sso_start_url = https://d-9567668ef9.awsapps.com/start
sso_region = ap-northeast-1
sso_account_id = 848148286183
sso_role_name = AdministratorAccess
region = ap-northeast-1
output = json
```

### 2. AWS SSO ログインでセッションを確立する

```bash
aws sso login --profile thinker-snowflake-terraform
```

sample

```bash
root@5af26cd0e0c8:/usr/src# aws sso login --profile thinker-snowflake-terraform
Attempting to automatically open the SSO authorization page in your default browser.
If the browser does not open or you wish to use a different device to authorize this request, open the following URL:

https://device.sso.ap-northeast-1.amazonaws.com/ # ブラウザでアクセスして、ログインする

Then enter the code:

MMBJ-XXXX # ブラウザで認証コード入力を求められた場合に設定する
Successfully logged into Start URL: https://d-9567668ef9.awsapps.com/start　# ログイン成功
```

### 3. Terraform Backend の設定

- {bucket}
  - 指定のバケット名を設定する
- dynamodb_table
  - 指定のテーブル名を設定する

```terraform
terraform {

  backend "s3" {
    bucket         = "{bucket}"
    key            = "terraform/resource/snowflake.tfstate"
    encrypt        = "true"
    region         = "ap-northeast-1"
    dynamodb_table = "{dynamodb_table}"
  }

  # backend "local" {
  #   path = "terraform.tfstate"
  # }
}

```


### 4. Terraform 実行ディレクトリにて terraform init

```bash
cd terraform/snowflake/accounts/main
terraform init
```

### 5. Terraform 実行ディレクトリにて terraform plan

実行計画を確認する

```bash
#cd terraform/snowflake/accounts/main
terraform plan
#TF_LOG_PROVIDER=DEBUG terraform plan
```

### 6. Terraform 実行ディレクトリにて terraform apply

実行完了後、Snowflake に反映されていることを確認

```bash
#cd terraform/snowflake/accounts/main
terraform apply
# → [ yes ] と入力
```

## テストなどの場合は、共通の state ファイルを使用しないように backend.tf を調整する

`terraform/snowflake/accounts/main/backend.tf`

```yml
terraform {

  # コメントアウトする
  # backend "s3" {
  #   bucket         = "terraform-state-thinker-snowflake-standard"
  #   key            = "terraform/resource/snowflake.tfstate"
  #   encrypt        = "true"
  #   region         = "ap-northeast-1"
  #   dynamodb_table = "thinker-snowflake-standard-terraform-state-lock"
  # }

  # コメントアウトを解除して、ローカルを使用する
  backend "local" {
    path = "terraform.tfstate"
  }
}

```

## GitPush 前に実施する

フォーマットでファイルを整形する

```bash
#cd terraform/snowflake/accounts/main
terraform fmt
```

秘密情報が含まれていないか確認する

- パスワード
- シークレットキー
- other...
