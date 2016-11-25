#!/bin/bash

awk 'BEGIN{
correct=0;
falpos=0;
falneg=0;
bothin=0;
bothout=0;
}
{
	if($1==1 && $2==1){correct+=1;bothin+=1;}
	if($1==-1 && $2==-1){correct+=1;bothout+=1;}
	if($1==-1 && $2==1){falpos+=1;}
	if($1==1 && $2==-1){falneg+=1;}
}
END{print "correct: " correct "; both inside: " bothin "; both outside: " bothout  "; false positive: " falpos "; false negtive: "  falneg}
' compareSign.txt
