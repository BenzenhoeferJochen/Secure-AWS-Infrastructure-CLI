#! /bin/bash
echo "Internet gateway name?"
read internet_gateway_name
echo $(aws ec2 create-internet-gateway --tag-specifications ResourceType=internet-gateway,Tags=["{Key=Name,Value=$internet_gateway_name}"] | grep -o "\"InternetGatewayId\": \".*" | cut -d "\"" -f 4)
