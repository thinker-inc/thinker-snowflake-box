-- create etl user
USE ROLE USERADMIN;
CREATE OR REPLACE USER TROCCO_USER
    --DEFAULT_WAREHOUSE = 'DIESEL_TROCCO_WH'
    COMMENT = 'Users with access to etl tools for client diesel';

-- 公開鍵を設定 refer: ./docs/snowflake_key_pair.md
ALTER USER TROCCO_USER SET RSA_PUBLIC_KEY='{PUBLIC_KEY}';

