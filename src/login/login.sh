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
    echo "Wich Region would you like to use? Default us-west-2"
    read aws_region
    echo "Wich Return Value Type would you like to use? Default json"
    read aws_output
	echo -e "[default]\n aws_access_key_id=$aws_access_key_id \n aws_secret_access_key=$aws_secret_access_key \n aws_session_token=$aws_session_token">/home/$(whoami)/.aws/credentials
	echo -e "[default]\n region = ${aws_region:-"us-west-2"}\n output = ${aws_output:-"json"}">/home/$(whoami)/.aws/config
    output=$(aws s3 ls 2>&1 >/dev/null)
done
echo "Sucessfully connected to AWS"