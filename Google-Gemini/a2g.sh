#!/bin/bash

cd $HOME/local/Google-Gemini
source ./venv/bin/activate
. ./env.sh

./a2g.py >/tmp/a2g.log 2>&1 &
