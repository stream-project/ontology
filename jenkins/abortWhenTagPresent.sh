#!/bin/bash

verifiedTag=`git tag --points-at HEAD | grep verified | wc -l`
verifiedTag=$(($verifiedTag + 1))

if [ $verifiedTag -gt 1 ]; then
    echo "The verified tag is present, thus stop pipeline here and deploy the vocabulary and documentation on Github."
    exit 1
fi
