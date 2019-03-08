#!/bin/bash
for i in `seq 1 50`
do
n1=$((RANDOM % 50 + 1))
n2=$((RANDOM % 50 + 1))
echo $n1 $n2 >>test.input.predict

if [ "$(($n1 + $n2))" -gt "50" ]
then
	echo -1>>test.label.predict
else
	echo "1">>test.label.predict
fi
done

