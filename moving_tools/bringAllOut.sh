# !/bin/bash
# il percorso di una cartella come parametro
# lo script porterà tutti i file annidati fuori dalle cartelle
# $1 cartella root


if [[ "$1" == "" ]]; then
	echo "usage: command {pathname}"
	exit
fi

cd "$1"
find . -mindepth 2 -type f -exec mv {} . \;

