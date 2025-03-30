#!/bin/bash

if [[ $# < 1 ]]; then
	echo "usage: command [dir]"
    echo "e vedrai che tutti i file in [dir] verranno organizzati in ordine alfabetico in una propria cartella"
	exit 0
fi

if [[ ! -d $1 ]]; then
    echo "fornire una cartella pls"
    exit 1
fi

find $1 -type f -maxdepth 1 -exec basename {} \; | while read -r file
do
    firstLetter=`echo ${file:0:1} | tr "a-z0123456789." "A-Z##########!"`
    mkdir -p "$1/$firstLetter"
    mv "$1/$file" "$1/$firstLetter"
done
