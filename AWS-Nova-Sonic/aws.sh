#!/bin/bash

cd $HOME/local/AWS-Nova-Sonic
source ./venv/bin/activate
. ./env.sh

./aws.py >/tmp/aws.log 2>&1 &
