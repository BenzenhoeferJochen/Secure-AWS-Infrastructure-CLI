#!/bin/bash
script_dir=$(realpath $(dirname $0))
bash $script_dir/login/login.sh 
vpc_id=$(bash $script_dir/vpc/create_vpc.sh | tee /dev/tty)| tail -1
private_route_table_id=$(bash $script_dir/route_table/create_route_table.sh $vpc_id "Private Route Table")
public_route_table_id=$(bash $script_dir/route_table/create_route_table.sh $vpc_id "Public Route Table")
public_subnets=$(bash $script_dir/subnet/main.sh $vpc_id $public_route_table_id "public")
private_subnets=$(bash $script_dir/subnet/main.sh $vpc_id $private_route_table_id "private")

