# 公開鍵・秘密鍵の生成

## 鍵の生成

鍵ペアを生成するためには、以下のコマンドを実行します。

```bash
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out snowflake_tf_snow_key.p8 -nocrypt
```

生成された秘密鍵を公開鍵に変換するためには、以下のコマンドを実行します。

```bash
openssl rsa -in snowflake_tf_snow_key.p8 -pubout -out snowflake_tf_snow_key.pub
```

公開鍵を整形する（改行と不要な箇所の除去）ためには、以下のコマンドを実行します。

```bash
cat snowflake_tf_snow_key.pub | \
tr -d "\n" | \
sed "s/-----BEGIN PUBLIC KEY-----//g" | \
sed "s/-----END PUBLIC KEY-----//g" \
&& echo ""
```

## Snowflakeへの公開鍵の登録

USERNAMEは、Snowflakeのユーザ名に置き換えてください。

```sql
-- sample
ALTER USER {USERNAME} SET RSA_PUBLIC_KEY='{PUBLIC_KEY}';
```

ユーザーパラメーター確認

- RSA_PUBLIC_KEY

```sql
DESC USER {USERNAME};
```