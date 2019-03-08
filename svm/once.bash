#!/bin/bash

lengthBound=40

length=$((1 + RANDOM % $lengthBound))
normalNumber=$((1 + RANDOM % $length))
specialNumber=$(($length-$normalNumber))



normalString=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $normalNumber | head -n 1)

specialchars='<>'

finalString=$normalString

for i in $(seq 1 $specialNumber)
do

randomchar=${specialchars:RANDOM % ${#specialchars}:1}

randompos=$(( RANDOM % ( ${#finalString} + 1 ) ))

tmpString=${finalString:0:randompos}${randomchar}${finalString:randompos}
finalString=$tmpString
done

echo $finalString>>input.dat
