#!/bin/bash

currentTag='git tag --points-at HEAD | wc -l'
currentTag=$(($currentTag + 1))

if [ $currentTag -gt 1 ]; then
    echo "$currentTag is the current tag thus this pipeline gets aborted."
    exit 1
fi
