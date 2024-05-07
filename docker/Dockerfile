FROM nikolaik/python-nodejs:python3.11-nodejs20

#ENV AWS_CLI_VER=2.13.20
ENV TERRAFORM_VER=1.8.2
ENV SERVERLESS_VERSION=3.33.0

# BASE
RUN apt update
RUN apt install -y \
      bash \
      git \
      curl \
      jq \
      less \
    && apt upgrade -y openssl \
    && apt install -y --fix-missing git openssl openssh-client curl unzip bash-completion

# AWS CLI
#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VER}.zip" -o "awscliv2.zip"
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Terraform
RUN git clone https://github.com/tfutils/tfenv ~/.tfenv
RUN ln -s ~/.tfenv/bin/* /usr/local/bin
RUN tfenv install $TERRAFORM_VER
RUN tfenv use $TERRAFORM_VER

# Serverless framework
# RUN npm install -g serverless@$SERVERLESS_VERSION
# RUN npm install -g serverless-better-credentials
# RUN npm install -g serverless-python-requirements
# RUN npm install -g aws-sdk
# RUN npm install -g serverless-deployment-bucket
# ENV AWS_SDK_LOAD_CONFIG 1

# SETUP
ENV SRCDIR /usr/src
RUN mkdir -p $SRCDIR
WORKDIR $SRCDIR
RUN mkdir /root/.ssh

CMD [ "/bin/bash", "-l" ]