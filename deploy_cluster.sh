#!/bin/bash

ARN=$1

# Grab all subnets into the account
# Get the first 4 subnet ids from the 4 first AZ's (sorted by name like az-a, az-b, az-c .. )
SUBNET_IDS=$(aws ec2 describe-subnets | jq '.Subnets | sort_by(.AvailabilityZone) | .[:4] | [ .[] .SubnetId ] | join(",")')

aws cloudformation create-stack --stack-name teastorestack --template-body file://cloudformation.yml \
--parameters ParameterKey=ClustersSubnetIds,ParameterValue=$SUBNET_IDS \
ParameterKey=ClustersARN,ParameterValue=$ARN