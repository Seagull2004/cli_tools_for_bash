#!/bin/bash
# Questo script permette di selezionare una cartella del telefono e sincronizzare
# il suo contenuto all'interno di una cartella di destinazione fornita in input
# - siccome è stato pensato per sincronizzare la cartella delle foto al momento non va a considerare ricorsivamente il contenuto della cartella in input
# - la sincronizzazione si occupa solo di controllare se il nome del file è presente o meno (non fa controlli sulla data di modifica)
# - per leggere il contenuto del telefono fa utilizzo di adb
#
#
# esempio di utlizzo:
# ./sync_phone_to_pc.sh /sdcard/DCIM/Camera /Volumes/home/Backups/michele 2024 
# ./sync_phone_to_pc.sh /sdcard/DCIM/Camera /Volumes/home/Backups/michele 2025 



# PRIMA PARTE: CONTROLLO PARAMETRI
#
#
#
# esattamente 3 parametri
# - source directory (on phone)
# - destination directory (maybe on NAS)
# - year to copy (bc file that will be sync must be e.g.: 2025-04-32......JPG)
if [[ $# -ne 3 ]]; then
    echo "Numero di parametri errato" 
    exit 1
fi
# entrambi i parametri non devono avere '/' come carattere finale
lastCharFirstParameter=${1:0-1}
if [[ $lastCharFirstParameter = '/' ]]; then
  echo " a directory must not end with '/' character" 
  exit 1
fi
lastCharSecondParameter=${2:0-1}
if [[ $lastCharSecondParameter = '/' ]]; then
  echo " a directory must not end with '/' character" 
  exit 1
fi
# entrami i parametri devono essere delle directory effettive
if adb shell "test ! -d \"$1\"" < /dev/null; then
    echo "$1 non è una directory" 
    exit 1
fi
if [[ ! -d "$2" ]]; then
    echo "$2 non è una directory" 
    exit 1
fi
# se la directory relativa all'anno non esiste viene creata
if [[ ! -d "$2/$3" ]]; then
    mkdir "$2/$3"
fi


# SECONDA PARTE: COPIA EFFETTIVA DEI FILE MANCANTI
# ciclando sui file del telefono per ogni file controllo la sua esistenza nella directory di destinazione
# se il file non è presente viene fatto un pull altrimenti skip
fileTotali=$(adb shell "ls \"$1/$3\"* | wc -l")
i=1
adb shell "find \"$1\" -type f -name \"$3*\" -exec basename {} \\;" | while read -r file; do
    echo "$i/$fileTotali"  
    if [[ -f "$2/$3/$file" ]]; then
        echo "file già presente: $file"
    else
        echo "trovato file mancante: $file"
        adb pull "$1/$file" "$2/$3" < /dev/null
    fi
    i=$((i + 1))
done
