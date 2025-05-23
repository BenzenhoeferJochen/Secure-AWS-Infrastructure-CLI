#! /bin/bash
output=$(aws s3 ls 2>&1 >/dev/null)
echo "Current output"
echo $output
while [[ $output =~ "An error occurred" || $output =~ "Unable to locate credentials." ]]
do
	echo "What is your aws access key id?"
	read aws_access_key_id
	echo "What is your aws secret access key?"
	read aws_secret_access_key
	echo "What is your aws session token?"
	read aws_session_token
	echo -e "[default]\n aws_access_key_id=$aws_access_key_id \n aws_secret_access_key=$aws_secret_access_key \n aws_session_token=$aws_session_token">/home/$(whoami)/.aws/credentials
	output=$(aws s3 ls 2>&1 >/dev/null)
done
echo "Sucessfully connected to AWS"
echo "CIDR Block"
read cidr_block
echo "Name"
read vpc_name
vpc_id=$(aws ec2 create-vpc --cidr-block $cidr_block --tag-specifications ResourceType=vpc,Tags=["{Key=Name,Value=$vpc_name}"])
vpc_id=$( echo $vpc_id | grep -o "\"VpcId\": \".*")
vpc_id=$( echo $vpc_id | cut -d "\"" -f 4)
public_route_table_id=$(aws ec2 create-route-table --vpc-id $vpc_id --tag-specifications ResourceType=route-table,Tags=["{Key=Name,Value=Public Route Table"}] | grep -o "\"RouteTableId\": \".*" | cut -d "\"" -f 4)
private_route_table_id=$(aws ec2 create-route-table --vpc-id $vpc_id --tag-specifications ResourceType=route-table,Tags=["{Key=Name,Value=Private Route Table}"] | grep -o "\"RouteTableId\": \".*" | cut -d "\"" -f 4)

echo "Number of public subnets?"
read public_subnets_number
declare -a public_subnets
for i in $(seq 1 $public_subnets_number)
do
	echo "CIDR Block"
	read cidr_block
	echo "Name"
	read sub_net_name
	public_subnets[$((i-1))]=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $cidr_block --tag-specifications ResourceType=subnet,Tags=["{Key=Name,Value=$sub_net_name}"] | grep -o "\"SubnetId\": \".*" | cut -d "\"" -f 4)
	aws ec2 associate-route-table --route-table-id $public_route_table_id --subnet-id ${public_subnets[$((i-1))]}
done

echo "Number of private subnets?"
read private_subnets_number
declare -a private_subnets
for i in $(seq 1 $private_subnets_number)
do
        echo "CIDR Block"
        read cidr_block
        echo "Name"
        read sub_net_name
        private_subnets[$((i-1))]=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $cidr_block --tag-specifications ResourceType=subnet,Tags=["{Key=Name,Value=$sub_net_name}"] | grep -o "\"SubnetId\": \".*" | cut -d "\"" -f 4)
	aws ec2 associate-route-table --route-table-id $private_route_table_id --subnet-id ${private_subnets[$((i-1))]}
done

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
