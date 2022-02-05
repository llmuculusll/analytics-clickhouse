## Environment Variable
```
mv .env.example
```


## Create Clickhouse User Password
```bash
PASSWORD=$(base64 < /dev/urandom | head -c8); echo "$PASSWORD"; echo -n "$PASSWORD" | sha256sum | tr -d '-'
```
The first line will be password and the second is corresponding SHA256. Keep the password in safe place and put the SHA256 password in .env for password_sha256_hex variable.

Your Clickhouse username by default is `analytics` but you can change it from `users.xml`.


## Create Schema for first time
```
docker exec -i clickhouse-single clickhouse-client  --multiquery -u analytics --password YOUR_PASSWORD < schema/schema.sql
```