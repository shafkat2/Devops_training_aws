#!/bin/bash

# propmts command for the bucket name
read -p 'Bucket_Name: ' bucket

# parse the json file to get if the bucket it enabled or not
status=$(aws s3api get-bucket-versioning --bucket $bucket | awk '{print $3}' | grep -o '[A-Z].*abled')

# checks the status and takes necessary action
if [ "$status" == 'Disabled' ]; 
then

  aws s3api put-bucket-versioning --bucket $bucket --versioning-configuration Status=Enabled

elif [ "$status" == 'Enabled' ];
then

  echo "bucket versioning already enabled"

else
  echo "error due to wrong api call or bad request"
fi

