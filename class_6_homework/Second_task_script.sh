#!/bin/bash

source=$1
bucket_dest=$2

# checks if the bucket is there or not
check_bucket=$(aws s3 ls | awk '/'$bucket_dest'/ {print $3}')

echo $check_bucket

# if not present creates the bucket
if [[ $check_bucket != $bucket_dest ]];
then
   aws s3api create-bucket --bucket $bucket_dest --region us-east-1
fi

# copy the contents from source to dest
aws s3 sync ./$source s3://$check_bucket

# check for bucket policy
status_bucket=$(aws s3api get-bucket-policy-status --bucket $check_bucket | awk '/IsPublic/ {print $3}'| grep -o "[a-z].*[a-z]")


# if no bucket policy deletes the block access
if [[ $status_bucket != 'true' ]];
then
   aws s3api delete-public-access-block --bucket $check_bucket
fi


# attaches the policy to the bucket
aws s3api put-bucket-policy --bucket $check_bucket --policy file://acl_policy.json

# configures the bucket website
aws s3api put-bucket-website --bucket $check_bucket --website-configuration file://website_conf.json

echo "please check URL"