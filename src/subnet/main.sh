#! /bin/bash
script_dir=$(realpath $(dirname $0))

echo "Number of $3 subnets?"
read subnets_number
declare -a subnets
for i in $(seq 1 $subnets_number)
do
    subnets[$((i-1))]=$(bash $script_dir/create_subnet.sh $1 | tee /dev/tty| tail -1)
	aws ec2 associate-route-table --route-table-id $2 --subnet-id ${subnets[$((i-1))]}
done
echo $subnets