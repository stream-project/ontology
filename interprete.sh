#!/bin/bash

lines=$(awk 'END{print NR}' RDFUnit_errors.txt)
#lines=$(($lines + 1))

    if [ $lines -gt 0 ]; then
	cat RDFUnit_errors.txt
	exit 1
    fi
