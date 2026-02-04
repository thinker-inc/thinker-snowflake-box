# TROCCO: FUNCTION USAGE 権限付与（PR貼り付け用メモ）

## 背景
- スプレッドシート連携（TROCCO）で実行するクエリ内で `DWH.INT.GET_FISCAL_PERIODS`（UDTF）が `TABLE(...)` 経由で呼ばれるケースがある。
- 実行ロールに **FUNCTION の `USAGE` が無い**場合、Snowflake は `Unknown user-defined table function` を返すことがある。

## 変更内容（Terraform plan 差分の要点）
### 追加する権限
対象ロールに対して、対象スキーマ配下の **ALL FUNCTIONS / FUTURE FUNCTIONS** に `USAGE` を付与する。

- **対象ロール**
  - `SR_TROCCO_IMPORT`
  - `SR_TROCCO_SPREADSHEET`
- **対象スキーマ**
  - `"DWH"."INT"`
  - `"MART"."TABLEAU_BI"`
- **付与する権限**
  - `USAGE` on **ALL FUNCTIONS** in schema
  - `USAGE` on **FUTURE FUNCTIONS** in schema

### 作成されるリソース（計 8 件）
> TROCCO 2ロール × 2スキーマ ×（ALL/FUTURE）= 8

- `snowflake_grant_privileges_to_account_role.trocco_all_functions_usage["import|\"DWH\".\"INT\""]`
- `snowflake_grant_privileges_to_account_role.trocco_all_functions_usage["import|\"MART\".\"TABLEAU_BI\""]`
- `snowflake_grant_privileges_to_account_role.trocco_all_functions_usage["spreadsheet|\"DWH\".\"INT\""]`
- `snowflake_grant_privileges_to_account_role.trocco_all_functions_usage["spreadsheet|\"MART\".\"TABLEAU_BI\""]`
- `snowflake_grant_privileges_to_account_role.trocco_future_functions_usage["import|\"DWH\".\"INT\""]`
- `snowflake_grant_privileges_to_account_role.trocco_future_functions_usage["import|\"MART\".\"TABLEAU_BI\""]`
- `snowflake_grant_privileges_to_account_role.trocco_future_functions_usage["spreadsheet|\"DWH\".\"INT\""]`
- `snowflake_grant_privileges_to_account_role.trocco_future_functions_usage["spreadsheet|\"MART\".\"TABLEAU_BI\""]`

## 実装の整理（定義の統合）
Looker Studio / TROCCO で重複していた FUNCTION USAGE grant の定義を、共通化して 1ファイルにまとめた。

- **変更前**
  - `terraform/snowflake/accounts/main/_looker_studio_function_usage.tf`（Looker Studio のみ）
  - `terraform/snowflake/accounts/main/_trocco_function_usage.tf`（TROCCO のみ）
- **変更後**
  - `terraform/snowflake/accounts/main/_function_usage_grants.tf` に統合

統合後は以下の考え方で管理する：
- **共通の対象スキーマ**: `local.function_usage_schemas`
- **ロール別の付与**:
  - Looker Studio: `SR_LOOKER_STUDIO` に対して ALL/FUTURE FUNCTIONS `USAGE`
  - TROCCO: `SR_TROCCO_IMPORT` / `SR_TROCCO_SPREADSHEET` に対して ALL/FUTURE FUNCTIONS `USAGE`

## （次段）module化について
Terraform の module（`terraform/snowflake/modules/`）として切り出すことも可能なため、`function_usage_grants` module を追加した。

- module: `terraform/snowflake/modules/function_usage_grants`
- **注意**: 既存の grant 定義を module 呼び出しへ置き換えるとリソースアドレスが変わるため、差分を大きくしないには `terraform state mv` 等の移行手順が必要。今回は **運用影響を避けるため、module は追加のみ（未適用）**としている。

## plan 実行コマンド（確認用）
> 認証ポリシー等の差分が混ざり得るため、該当 grant のみ `-target` で確認する。

```bash
terraform -chdir=terraform/snowflake/accounts/main plan -input=false \
  -target='snowflake_grant_privileges_to_account_role.looker_studio_all_functions_usage' \
  -target='snowflake_grant_privileges_to_account_role.looker_studio_future_functions_usage' \
  -target='snowflake_grant_privileges_to_account_role.trocco_all_functions_usage' \
  -target='snowflake_grant_privileges_to_account_role.trocco_future_functions_usage'
```

## 実装ファイル
- `terraform/snowflake/accounts/main/_function_usage_grants.tf`

