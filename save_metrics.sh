#!/bin/bash

INTERNAL_IP=$1
INSTANCE_ID=$(aws ec2 describe-instances --filter Name=private-ip-address,Values=$INTERNAL_IP | jq -r .Reservations[0].Instances[0].InstanceId)

aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization \
 --dimensions Name=InstanceId,Value=$INSTANCE_ID \
 --statistics Average \
 --start-time $(date -d 'now -45 minutes' +"%Y-%m-%dT%H:%M:%S%z") \
 --end-time $(date +"%Y-%m-%dT%H:%M:%S%z") \
 --period 300 \
 --region us-east-1 \
 | jq -r '.Datapoints[] | [.Timestamp, .Average, .Unit] | @csv' > $INSTANCE_ID-cpu.csv
