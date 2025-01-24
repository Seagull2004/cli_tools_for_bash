#!/bin/bash

if [[ ! -d $1 ]]; then
    echo "inserire il nome di una cartella pls" 
fi



find $1 -type f -maxdepth 1 | while read -r file; do
    echo "====> $file"
    originalDate=`exiftool -createdate "$file" | tr -s " " | cut -d " " -f 4-`
    exiftool "-filemodifydate=$originalDate" "$file"
done


