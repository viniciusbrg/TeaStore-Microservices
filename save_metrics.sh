#!/bin/bash

PREFIX=$1
INTERNAL_IP=$2
INSTANCE_ID=$(aws ec2 describe-instances --filter Name=private-ip-address,Values=$INTERNAL_IP | jq -r .Reservations[0].Instances[0].InstanceId)

aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization \
 --dimensions Name=InstanceId,Value=$INSTANCE_ID \
 --statistics Average \
 --start-time $(date -d 'now -30 minutes' +"%Y-%m-%dT%H:%M:%S%z") \
 --end-time $(date +"%Y-%m-%dT%H:%M:%S%z") \
 --period 300 \
 --region us-east-1 \
 | jq -r '.Datapoints[] | [.Timestamp, .Average, .Unit] | @csv' > $PREFIX-$INSTANCE_ID-cpu.csv

aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name NetworkIn \
 --dimensions Name=InstanceId,Value=$INSTANCE_ID \
 --statistics Average \
 --start-time $(date -d 'now -30 minutes' +"%Y-%m-%dT%H:%M:%S%z") \
 --end-time $(date +"%Y-%m-%dT%H:%M:%S%z") \
 --period 300 \
 --region us-east-1 \
 | jq -r '.Datapoints[] | [.Timestamp, .Average, .Unit] | @csv' > $PREFIX-$INSTANCE_ID-networkin.csv

aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name NetworkOut \
 --dimensions Name=InstanceId,Value=$INSTANCE_ID \
 --statistics Average \
 --start-time $(date -d 'now -30 minutes' +"%Y-%m-%dT%H:%M:%S%z") \
 --end-time $(date +"%Y-%m-%dT%H:%M:%S%z") \
 --period 300 \
 --region us-east-1 \
 | jq -r '.Datapoints[] | [.Timestamp, .Average, .Unit] | @csv' > $PREFIX-$INSTANCE_ID-networkout.csv

