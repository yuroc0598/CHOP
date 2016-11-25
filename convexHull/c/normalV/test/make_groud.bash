#!/bin/bash

awk '{
if ($1+20>1000000-$3 || $2+20>1000000-$3)
    print -1
else
    print 1
}' $1
