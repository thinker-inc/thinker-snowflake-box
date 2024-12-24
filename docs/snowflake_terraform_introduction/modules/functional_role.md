# 概要

---

- 「Functional Roleを作成するリソース」と「作成したFunctional Roleを各ユーザーにGRANTするリソース」をModuleとして定義しています。

## 各種ファイル

---

## main.tf

各種リソースをまとめて定義しています。

- Functional Roleの作成だけでなく、ユーザーへのGRANTも行う。GRANT先のユーザーリストは`grant_usage_ar_to_fr_set`で受け取る
- Functional RoleはSYSADMINにもGRANTすることで、SYSADMINが全てのFunctional Roleの親となるようにする

- **CODE**

    ```toml
    # Functional Roleの作成
    resource "snowflake_role" "this" {
      name    = upper(var.role_name)
      comment = var.comment
    }
    
    # Functional Roleをユーザーにgrant
    resource "snowflake_grant_account_role" "grant_to_user" {
      for_each = var.grant_user_set
    
      role_name = upper(var.role_name)
      user_name = each.value
    
      depends_on = [snowflake_role.this]
    }
    
    # SYSADMINにFunctional Roleをgrant
    resource "snowflake_grant_account_role" "grant_to_sysadmin" {
      role_name        = upper(var.role_name)
      parent_role_name = "SYSADMIN"
    
      depends_on = [snowflake_role.this]
    }
    ```

## **outputs.tf**

- 他のModuleから作成したFunctional Role名を参照できるように、**`name`**だけoutputとして定義しています。

- **CODE**

    ```toml
    output "name" {
      description = "Name of the functional_role."
      value       = snowflake_role.this.name
    }
    ```

## **variables.tf**

- Moduleを使用するときに必要な各変数を定義しています。基本的に**`snowflake_role`**リソースで使う値を定義しています。
- Functionalを付与したいユーザーをModule使用時に受け取るために**`grant_user_set`**も定義しています。

- **CODE**

    ```toml
    variable "role_name" {
      description = "Name of the functional role"
      type        = string
      default     = null
    }
    
    variable "comment" {
      description = "Write description for the functional role"
      type        = string
      default     = null
    }
    
    variable "grant_user_set" {
      description = "Set of user for grant functional role"
      type        = set(string)
      default     = []
    }
    
    ```
