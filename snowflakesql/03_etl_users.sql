-- create etl user
USE ROLE USERADMIN;

-- ETL Userは、Terraformで作成する
-- 公開鍵を設定 refer: ./docs/snowflake_key_pair.md
ALTER USER ETL_USER SET RSA_PUBLIC_KEY='{PUBLIC_KEY}';

