#!/bin/bash

awk 'BEGIN{sum=0;}{
	if(4*($3+$4)+$5>49){print NR;
	sum+=1;
	}


}
END{print sum}
' $1
