#!/bin/bash

cd $HOME/local/a2g
source ./venv/bin/activate
. ./env.sh

./a2g.py >/tmp/a2g.log 2>&1 &
