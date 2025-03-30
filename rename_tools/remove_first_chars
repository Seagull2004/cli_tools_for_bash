# !/bin/bash

if [[ ! -d $1 ]]; then
    echo "scegliere una cartella valida"
    exit
fi

lastChar=`echo $1 | rev`
lastChar=${lastChar:0:1}

if [[ $lastChar == "/" ]]; then
    echo "pls rimuovi '/' dalla file del parametro" 
    exit
fi


find "$1" -type file -name "*.mp3" -exec basename {} \; | while read -r fileName; do
    # un file del tipo '123 - ciao_mondo.mp3"
    # diventa del tipo 'ciao_mondo.mp3"
    newFileName=`echo $fileName | cut -d " " -f 3-`
	mv "$1/$fileName" "$1/$newFileName"
done
