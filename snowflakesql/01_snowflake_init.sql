-- Variables
SET TIMEZONE='Asia/Tokyo';

-- パラメーター確認
-- https://docs.snowflake.com/ja/sql-reference/parameters
USE ROLE SYSADMIN;
SHOW PARAMETERS IN ACCOUNT;
SHOW PARAMETERS IN USER;
SHOW PARAMETERS IN SESSION;

-- ABORT_DETACHED_QUERYの設定
-- https://docs.snowflake.com/ja/sql-reference/parameters#abort-detached-query
SHOW PARAMETERS like 'ABORT_DETACHED_QUERY' IN ACCOUNT;
SHOW PARAMETERS like 'ABORT_DETACHED_QUERY' IN USER;
SHOW PARAMETERS like 'ABORT_DETACHED_QUERY' IN SESSION;

USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET ABORT_DETACHED_QUERY = TRUE;

USE ROLE SYSADMIN;
ALTER SESSION SET ABORT_DETACHED_QUERY = TRUE;

-- アカウントのTimezoneをJSTに変更
-- https://docs.snowflake.com/ja/sql-reference/parameters#timezone
-- SELECT CURRENT_TIMESTAMP;
SHOW PARAMETERS LIKE 'TIMEZONE';

USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET TIMEZONE = $TIMEZONE;

-- DATA_RETENTION_TIME_IN_DAYS
-- https://docs.snowflake.com/ja/sql-reference/parameters#data-retention-time-in-days
-- alter account set data_retention_time_in_days = 3;
SHOW PARAMETERS like '%DATA_RETENTION_TIME_IN_DAYS%' in account;