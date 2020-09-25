#!/bin/bash

# Check bestemmioni
# (C) Copyright 2020 Diavolo aka Belzebù

recursive()
{
    if [[ -f $f && ${f} != ${filename} ]]; then
    	while read line; 
    	do
    		if grep ${line} ${f}; then
        		echo "FOUND ${line} in ${f}"
        	fi
    	done < $filename
    	count=$(($count+1))
    	echo "${count} files scanned."
    elif [[ -d $f ]];then
    	for i in $(ls $f)
	       	do
	       		f=$i
	       		recursive $i
	       	done
    fi
}
f=$(pwd)
count=0
filename=$1
if [[ -z $filename || ! -e $filename ]];then
	echo "Filename doesn't exist"
	echo "Example:"
	echo "	./check_bestemmioni smadonnate.txt"
	exit 1
fi
recursive