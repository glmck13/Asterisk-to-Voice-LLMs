#!/usr/bin/env bash

cd $HOME/local
source ./awsenv/bin/activate
. ./env.sh

./aws.py >/tmp/aws.log 2>&1 &
