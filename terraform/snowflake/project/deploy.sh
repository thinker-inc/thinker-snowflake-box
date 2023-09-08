#!/bin/bash
set -e

COMMAND=$1
WORKSPACE=$2

# ローカルでの開発時に環境切り分け用に記載
. ./env/${WORKSPACE}.sh

terraform workspace select ${WORKSPACE}
terraform ${COMMAND} 
#-var-file=./env/${WORKSPACE}.tfvars