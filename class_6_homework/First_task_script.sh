 #!/bin/bash

 
read -p 'Bucket_Name: ' bucket

status=$(aws s3api get-bucket-versioning --bucket $bucket | awk '{print $3}' | grep -o '[A-Z].*abled')

if [ "$status" == 'Disabled' ]; 
then

  aws s3api put-bucket-versioning --bucket $bucket --versioning-configuration Status=Enabled

elif [ "$status" == 'Enabled' ];
then

  echo "bucket versioning already enabled"

else
  echo "error due to wrong api call or bad request"
fi

