#!/bin/bash

echo "$0: Testing R, W, R, Rl, Rl, Rl"
echo "expected output:\nfoo\nbar"
echo "starting:"
echo foo | ./osprdaccess -w -l
./osprdaccess -r -l -d 5 &
echo bar | ./osprdaccess -w -l &
sleep 1
./osprdaccess -r -l
