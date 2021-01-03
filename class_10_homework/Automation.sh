#!/bin/bash


vpc_cidr_block=$1
subnet_one=$2
subnet_two=$3

# create vpc
vpc_value=$(aws ec2 create-vpc --cidr-block $vpc_cidr_block| grep -n "VpcId" | aws '{print $2}' | grep -o "[a-z].*.[0-9]" )

# create subnet
aws ec2 create-subnet --vpc-id vpc-2f09a348 --cidr-block $subnet_one

aws ec2 create-subnet --vpc-id vpc-2f09a348 --cidr-block $subnet_one

#create internet gateway
internet_gateway=$(aws ec2 create-internet-gateway | grep -n "InternetGatewayId" | aws '{print $2}' | grep -o "[a-z].*.[0-9 a-z]" )

# attach gateway
aws ec2 attach-internet-gateway --vpc-id $vpc_value --internet-gateway-id $internet_gateway

# route table
route_table=$(aws ec2 create-route-table --vpc-id $vpc_value | grep -n "RouteTableId" | aws '{print $2}' | grep -o "[a-z].*.[0-9 a-z]" )

# create route
aws ec2 create-route --route-table-id $route_table --destination-cidr-block 0.0.0.0/0 --gateway-id $internet_gateway

# get subnet to attach route
subnet_to_attached=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_value" --query 'Subnets[*].{ID:SubnetId,CIDR:CidrBlock}' | grep -n "ID" |aws '{print $2}' | grep -o "[a-z].*.[a-z]" )

echo $subnet_to_attached

# route attached to subnet
aws ec2 associate-route-table  --subnet-id $subnet_to_attached --route-table-id route_table