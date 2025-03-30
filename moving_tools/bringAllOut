#!/bin/bash
# il percorso di una cartella come parametro
# lo script porterà tutti i file annidati fuori dalle cartelle
# $1 cartella root


if [[ $# < 1 ]]; then
	echo "usage: command [dir]"
    echo "e vedrai che tutti i file annidati nelle sottocartelle di [dir] verranno spostati in [dir]"
	exit 0
fi

if [[ ! -d $1 ]]; then
    echo "fornire una cartella pls"
    exit 1
fi

find "$1" -mindepth 2 -type f -exec mv {} "$1" \;
