#!/bin/bash

lines=`git diff-index --name-only HEAD | wc -l`
lines=$(($lines + 1))
if [ $lines -gt 1 ]; then
    git commit -m "Update the extracted classes by HermiT"
fi
