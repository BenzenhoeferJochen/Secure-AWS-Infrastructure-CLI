#!/bin/bash
script_dir=$(realpath $(dirname $0))
bash $script_dir/login/login.sh 
vpc_id=$(bash $script_dir/vpc/create_vpc.sh | tee /dev/tty| tail -1)
private_route_table_id=$(bash $script_dir/route_table/create_route_table.sh $vpc_id "Private Route Table" | tee /dev/tty| tail -1)
public_route_table_id=$(bash $script_dir/route_table/create_route_table.sh $vpc_id "Public Route Table" | tee /dev/tty| tail -1)
public_subnets=$(bash $script_dir/subnet/main.sh $vpc_id $public_route_table_id "public" | tee /dev/tty| tail -1)
private_subnets=$(bash $script_dir/subnet/main.sh $vpc_id $private_route_table_id "private" | tee /dev/tty| tail -1)


echo "Internet gateway name?"
read internet_gateway_name
internet_gateway_id=$(aws ec2 create-internet-gateway --tag-specifications ResourceType=internet-gateway,Tags=["{Key=Name,Value=$internet_gateway_name}"] | grep -o "\"InternetGatewayId\": \".*" | cut -d "\"" -f 4)

aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $internet_gateway_id

#aws ec2 associate-route-table --route-table-id $public_route_table_id --gateway-id $internet_gateway_id

aws ec2 create-route --route-table-id $public_route_table_id --destination-cidr-block 0.0.0.0/0 --gateway-id $internet_gateway_id

security_group_id=$(aws ec2 create-security-group --group-name PublicSecurityGroup --description "Allow access only from my IP via ssh" --vpc-id $vpc_id | grep -o "\"GroupId\": \".*" | cut -d "\"" -f 4)
echo $security_group_id
aws ec2 authorize-security-group-ingress --group-id $security_group_id --protocol tcp --port 22 --cidr "$(curl https://ipinfo.io/ip)/32"
keyname=$(aws ec2 describe-key-pairs --query 'KeyPairs[0].KeyName' --output text)
aws ec2 run-instances --image-id ami-07b0c09aab6e66ee9 --instance-type t3.micro --security-group-ids $security_group_id --subnet-id ${public_subnets[0]} --associate-public-ip-address --key-name "$keyname"
aws ec2 run-instances --image-id ami-07b0c09aab6e66ee9 --instance-type t3.micro --subnet-id ${private_subnets[0]} --key-name "$keyname"
