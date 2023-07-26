FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y vim wget sudo unzip
RUN wget https://releases.hashicorp.com/terraform/1.5.3/terraform_1.5.3_linux_amd64.zip \
    && unzip ./terraform_1.5.3_linux_amd64.zip -d /usr/local/bin \
    && rm ./terraform_1.5.3_linux_amd64.zip

COPY ./terraform/ /usr/src/
WORKDIR /usr/src/environments/common/
CMD ["terraform", "init"]