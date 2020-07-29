#!/bin/sh

lines='cat ./RDFUnit_errors.txt | wc -l'
lines=$(($lines + 1))

    if [ $lines -gt 3 ]; then
	cat RDFUnit_errors.txt
	exit 1;
    fi
