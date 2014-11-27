#!/bin/bash

./fsFixer fs.img > /dev/null 2>&1

# Test: corrupts the bitmap.
echo "Test1: Corrupt the bitmap."
cp fs.img fs1.img
x=`./test r 2048 20 fs1.img`
./test w 2050 1 fs1.img > /dev/null 2>&1
./test r 2048 20 fs1.img > /dev/null 2>&1
./fsFixer fs1.img > /dev/null 2>&1
y=`./test r 2048 20 fs1.img`
if [ "$x" = "$y" ]
then
    echo "pass"
else
    echo "fail"
fi

echo "Test2: Corrupting the inode blk."
cp fs.img fs2.img
./fsFixer fs2.img
./test w 108544 0 fs2.img
./fsFixer fs2.img > /dev/null 2>&1
./fsFixer fs2.img
