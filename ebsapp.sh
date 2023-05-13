#!/bin/bash

# Read from ebsapp.yaml
while IFS= read -r line; do
  ec2_instance_id=$(echo $line | awk '{print $2}')
  name=$(echo $line | awk '{print $4}')

  # Get a list of EBS volumes attached to the EC2 instance
  volume_ids=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$ec2_instance_id --query 'Volumes[*].VolumeId' --output text)

  # Create a snapshot for each EBS volume
  for volume_id in $volume_ids; do
    snapshot_description="$name-$(date +%Y%m%d%H%M%S)"
    aws ec2 create-snapshot --volume-id $volume_id --description "$snapshot_description"
  done
done < ebsapp.yaml
