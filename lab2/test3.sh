#!/bin/bash

echo "$0: Testing W, W, Rl, Rl"
echo "expected output:\nbar"
echo "starting:"
echo foo | ./osprdaccess -w -l -d 10 &
echo bar | ./osprdaccess -w -l &
./osprdaccess -r -l
