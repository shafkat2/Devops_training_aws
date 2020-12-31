#!/bin/bash

source=$1
bucket_dest=$2



# create bucket
aws s3api create-bucket --bucket $bucket_dest --region us-east-1


# copy the contents from source to dest
aws s3 sync ./$source s3://$bucket_dest

# check for bucket policy
status_bucket=$(aws s3api get-bucket-policy-status --bucket $bucket_dest | awk '/IsPublic/ {print $3}'| grep -o "[a-z].*[a-z]")


# if no bucket policy deletes the block access
if [[ $status_bucket != 'true' ]];
then
   aws s3api delete-public-access-block --bucket $bucket_dest
fi


# attaches the policy to the bucket
aws s3api put-bucket-policy --bucket $bucket_dest --policy file://acl_policy.json

# configures the bucket website
aws s3api put-bucket-website --bucket $bucket_dest --website-configuration file://website_conf.json

echo "please check URL"
