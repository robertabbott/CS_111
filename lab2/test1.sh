#!/bin/bash

echo "$0: Testing R, R, Rl, Rl"
echo "expected output:\nfoo\nfoo"
echo "starting:"
echo foo | ./osprdaccess -w -l
./osprdaccess -r -l -d 5 &
./osprdaccess -r -l
