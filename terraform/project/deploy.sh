#!/bin/bash
set -e

COMMAND=$1
WORKSPACE=$2

terraform workspace select ${WORKSPACE}
terraform ${COMMAND} -var-file=./env/${WORKSPACE}.tfvars