#!/bin/bash

# Now read RDFUnit report
lines=$(awk 'END{print NR}' RDFUnit_errors_.txt)
if [ $lines -gt 12 ]; then
	cat RDFUnit_errors_.txt
	#exit 1
fi
