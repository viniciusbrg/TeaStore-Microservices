#!/bin/bash

for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"

   export "$KEY"="$VALUE"
done

TEASTORE_INSTANCE_TYPE="${TEASTORE_INSTANCE_TYPE:-c4.xlarge}"
TEASTORE_INSTANCES="${TEASTORE_INSTANCES:-2}"
LOCUST_INSTANCES="${LOCUST_INSTANCES:-2}"
LOCUST_INSTANCE_TYPE="${LOCUST_INSTANCE_TYPE:-t3.medium}"


# Grab all subnets into the account
# Get the first 4 subnet ids from the 4 first AZ's (sorted by name like az-a, az-b, az-c .. )
SUBNET_IDS=$(aws ec2 describe-subnets | jq '.Subnets | sort_by(.AvailabilityZone) | .[:4] | [ .[] .SubnetId ] | join(",")')

aws cloudformation create-stack --stack-name teastorestack --template-body file://cloudformation.yml \
--parameters ParameterKey=ClustersSubnetIds,ParameterValue=$SUBNET_IDS \
ParameterKey=TeastoreInstanceType,ParameterValue=$TEASTORE_INSTANCE_TYPE \
ParameterKey=TeastoreInstances,ParameterValue=$TEASTORE_INSTANCES \
ParameterKey=LocustInstances,ParameterValue=$LOCUST_INSTANCES \
ParameterKey=LocustInstanceType,ParameterValue=$LOCUST_INSTANCE_TYPE \
ParameterKey=ClustersARN,ParameterValue=$ARN