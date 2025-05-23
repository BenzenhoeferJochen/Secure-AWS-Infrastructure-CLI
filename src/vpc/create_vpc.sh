#! /bin/bash
echo "CIDR Block"
read cidr_block
echo "Name"
read vpc_name
echo $(aws ec2 create-vpc --cidr-block $cidr_block --tag-specifications ResourceType=vpc,Tags=["{Key=Name,Value=$vpc_name}"] --query 'Vpc.VpcId' --output text)
