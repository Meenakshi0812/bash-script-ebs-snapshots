#!/bin/bash

# Read keyword from YAML file
KEYWORD=$(cat ebsapp.yaml | grep "keyword" | cut -d ":" -f 2 | tr -d '[:space:]')

# Find EC2 instance IDs based on the keyword and running state
INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*${KEYWORD}*" "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].InstanceId' --output text)

# Loop through each instance ID
for INSTANCE_ID in $INSTANCE_IDS; do
    # Get the EC2 instance name
    INSTANCE_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=${INSTANCE_ID}" "Name=key,Values=Name" --query 'Tags[0].Value' --output text)

    # Find the attached volumes for the instance
    VOLUME_IDS=$(aws ec2 describe-volumes --filters "Name=attachment.instance-id,Values=${INSTANCE_ID}" --query 'Volumes[*].VolumeId' --output text)

    # Loop through each volume ID
    for VOLUME_ID in $VOLUME_IDS; do
        # Create a snapshot of the volume
        SNAPSHOT_ID=$(aws ec2 create-snapshot --volume-id ${VOLUME_ID} --description "Snapshot created for EC2-instance ${INSTANCE_NAME}" --query 'SnapshotId' --output text)

        # Set the snapshot name as the instance name
        aws ec2 create-tags --resources ${SNAPSHOT_ID} --tags "Key=Name,Value=${INSTANCE_NAME}"

        # Output the snapshot ID and volume ID
        echo "Created snapshot ${SNAPSHOT_ID} for volume ${VOLUME_ID} of EC2-instance ${INSTANCE_NAME}"
    done
done
