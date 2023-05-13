#!/bin/bash

# Load instance IDs from ebsapp.yaml
instances=($(yq eval '.instances[].ec2_instance_id' ebsapp.yaml))

 # Loop through instances and create snapshots of their EBS volumes
for instance in "${instances[@]}"

do

  volumes=($(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instance --query 'Volumes[].VolumeId' --output text))

   for volume in "${volumes[@]}"

  do

    aws ec2 create-snapshot --volume-id $volume --description "Snapshot of EBS volume $volume on instance $instance"

  done

done