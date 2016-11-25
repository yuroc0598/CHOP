#!/bin/bash
while read line
do
	LN=$((line + 2))
	sed  "${LN}q;d" $2
done < $1
