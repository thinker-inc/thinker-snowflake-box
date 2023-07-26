# thinker-snowflake-terraform
## Docker
```sh
docker build . -t snowflake-terraform
docker run --name snowflake-terraform -it -d -v $PWD/terraform/:/usr/src snowflake-terraform /bin/bash
```