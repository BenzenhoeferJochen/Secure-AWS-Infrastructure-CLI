#! /bin/bash
echo "CIDR Block"
read cidr_block
echo "Name"
read sub_net_name
echo $(aws ec2 create-subnet --vpc-id $1 --cidr-block $cidr_block --tag-specifications ResourceType=subnet,Tags=["{Key=Name,Value=$sub_net_name}"] | grep -o "\"SubnetId\": \".*" | cut -d "\"" -f 4)