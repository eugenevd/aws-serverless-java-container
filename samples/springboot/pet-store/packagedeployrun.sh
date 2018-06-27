#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Specify bucketname as first param"
  exit 1
fi

BUCKETNAME="$1"

echo Maven
 mvn package

echo Cloudformation package
 aws cloudformation package --template-file sam.yaml --output-template-file output-sam.yaml --s3-bucket ${BUCKETNAME}

echo Cloudformation deploy
 aws cloudformation deploy --template-file output-sam.yaml --stack-name MySampleStack --capabilities CAPABILITY_IAM
 URL_PETSTORE=$(aws cloudformation describe-stacks --stack-name MySampleStack | grep OutputValue | cut -d"\"" -f4)

echo Execute fn
 curl ${URL_PETSTORE}?limit=2 | python -m json.tool
