-- create etl user
USE ROLE USERADMIN;

-- Create with terraform
-- CREATE OR REPLACE USER ETL_USER
--     COMMENT = 'Users with access to etl tools for client A';

-- 公開鍵を設定 refer: ./docs/snowflake_key_pair.md
ALTER USER ETL_USER SET RSA_PUBLIC_KEY='{PUBLIC_KEY}';

