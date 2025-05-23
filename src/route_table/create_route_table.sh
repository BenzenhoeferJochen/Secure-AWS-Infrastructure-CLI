echo $(aws ec2 create-route-table --vpc-id $1 --tag-specifications ResourceType=route-table,Tags=["{Key=Name,Value=$2"}] --query "RouteTable.RouteTableId" --output text)
