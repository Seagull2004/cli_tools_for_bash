#!/bin/bash

find $1 -type f -maxdepth 1 -exec basename {} \; | while read -r file
do
    firstLetter=`echo ${file:0:1} | tr "a-z" "A-Z"`
    mv "$1/$file" "$1/$firstLetter"
done
