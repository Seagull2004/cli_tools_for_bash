#!/bin/bash
# Questo dannato script si occupa di sostituire tutte le occorrenze di percordi in stile Unix
# tipo: /Volumes/home/percorso/di/qualcosa
# in percordi stile windows
# tipo: \NAS\home\
# qualora questo percorso sia presente all'intero di un tag
# (utile per capire come usare il potentissimo comando awk)

if [[ $# == 0 ]]; then
    echo "usage: path_replacer.sh [file path]" 
    exit 1
fi

file_name=$1

if [[ ! -f $file_name ]]; then
    echo "il file passato non esiste, ocio"
    echo `ls`
    exit 1
fi

echo -n "attenzione, questo programma è stato creato per un uso molto specifico e mirato, sicuro di voler procedere? [y/n] > "
read answer

if [[ $answer != "y" ]]; then
    echo "ok dai, arrivederci"
    exit 0
fi
echo "procediamo"

# I FASE
# In questa prima fase ci occupiamo solo di sostituire le occorenze di '/Volumes' con '\NAS'
awk -v search="/Volumes" -v replace="/NAS" '{gsub(search, replace)} 1' "$file_name" > tmpfile
mv tmpfile "$file_name"

# II FASE
# Si occupa di sostituire '/' -> '\' nelle righe in cui è presente la parola chiave NAS 
# ossia dove si sta parlando di un effettivo percorso
awk -v pattern="/NAS.*<" '{
	if (match($0, pattern)) {
		captured_text = substr($0, RSTART, RLENGTH)
		gsub("\/", "\\", captured_text)
		gsub(pattern, captured_text)
	}
} 1' "$file_name" > tmpfile
mv tmpfile "$file_name"
