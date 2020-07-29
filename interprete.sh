#!/bin/sh

lines='wc -l RDFUnit_errors.txt'
lines=$(($lines + 1))

    if [ $lines -gt 3 ]; then
	cat RDFUnit_errors.txt
	exit 1;
    fi
