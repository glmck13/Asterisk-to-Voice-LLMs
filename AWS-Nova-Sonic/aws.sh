#!/bin/bash

cd $HOME/local/aws
source ./venv/bin/activate
. ./env.sh

./aws.py >/tmp/aws.log 2>&1 &
