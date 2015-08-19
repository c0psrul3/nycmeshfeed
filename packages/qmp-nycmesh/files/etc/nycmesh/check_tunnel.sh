#!/bin/sh

#rev 0

interfaces="tap0"
bmx6 -c --tunmtu 1300
bmx6 -c -i tap0 /rateMax 10000 /rateMin 10000

for i in $interfaces
do
	echo "checking $i"
	
	if bmx6 -c --interfaces |grep -q $i ; then
		echo "$i found"
	else
		echo "$i not found"
                bmx6 -c -i $i
       	fi
done
