#!/bin/bash

lines=`git status | wc -l`
if [ $lines -gt 4 ]; then
    git commit -m "Update the extracted classes by HermiT"
fi
