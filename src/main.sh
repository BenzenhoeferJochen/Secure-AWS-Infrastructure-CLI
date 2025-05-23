#!/bin/bash
bash login/login.sh 
vpc_id=$(bash vpc/create_vpc.sh | tee /dev/tty)| tail -1
private_route_table_id=$(bash route_table/create_route_table.sh $vpc_id "Private Route Table")
public_route_table_id=$(bash route_table/create_route_table.sh $vpc_id "Public Route Table")

