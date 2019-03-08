#!/bin/bash


#awk 'BEGIN{FS=" "}
#{
#    if($1==1)   
#    print  $2, $3, $4, $5, $6, $7, $8 >>"train.vectors.normal";
#else 
#    print  $2, $3, $4, $5, $6, $7, $8 >>"train.vectors.bug";
#   }' matrix.train
#
awk 'BEGIN{FS=" "}
{
    if($1==1)   
    print  $2, $3, $4, $5, $6, $7, $8 >>"predict.vectors.normal";
else 
    print  $2, $3, $4, $5, $6, $7, $8 >>"predict.vectors.bug";
   }' matrix.predict
