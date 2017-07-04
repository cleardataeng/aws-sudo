#!/usr/bin/env bash

set -e

session_name=aws_sudo

while [ "$#" -gt 0 ]; do
    case "$1" in
        -n) session_name="$2"; shift 2;;
        -c) command="$2"; shift 2;;
        -x) clear=1; shift 1;;
        *) argument=$1; shift 1;;
    esac
done

if [ "$argument" = "clear" -o "$clear" = "1" ]
then
	echo "unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN AWS_SESSION_TOKEN"
	exit
fi

response=$(aws sts assume-role --output text \
               --role-arn "$argument" \
               --role-session-name="$session_name" \
               --query Credentials)

if [ -n "$command" ]; then
    env -i \
        AWS_ACCESS_KEY_ID=$(echo $response | awk '{print $1}') \
        AWS_SECRET_ACCESS_KEY=$(echo $response | awk '{print $3}') \
        AWS_SESSION_TOKEN=$(echo $response | awk '{print $4}') \
        sh -c "$command"
else
    echo export \
         AWS_ACCESS_KEY_ID=$(echo $response | awk '{print $1}') \
         AWS_SECRET_ACCESS_KEY=$(echo $response | awk '{print $3}') \
         AWS_SESSION_TOKEN=$(echo $response | awk '{print $4}')
fi
