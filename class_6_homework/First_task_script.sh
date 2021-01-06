#!/bin/bash

# propmts command for the bucket name
bucket=$1
file_name=$2

# parse the json file to get if the bucket it enabled or not
status=$(aws s3api get-bucket-versioning --bucket $bucket | awk '{print $2}' | grep -o '[A-Z].*.[a-z]')
echo $status
# checks the status and takes necessary action
if [ "$status" == 'Suspended' ]; 
then

  aws s3api put-bucket-versioning --bucket $bucket --versioning-configuration Status=Enabled

elif [ "$status" == 'Enabled' ];
then

  echo "bucket versioning already enabled"

else
  echo "error due to wrong api call or bad request"
fi
aws s3api delete-public-access-block --bucket $bucket

file_name_version_id=$(aws s3api delete-objects --bucket izaan-it-version-check --delete file://delete.json | awk '/DeleteMarkerVersionId/ {print $2}' | grep -o "[a-z A-Z 0-9].*.[a-z A-Z 0-9]")

aws s3api get-object --bucket $bucket --key $file_name --version-id $file_name_version_id $file_name
