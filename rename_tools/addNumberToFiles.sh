# !/bin/bash
# rinomina una lista di file .mp3 all'interno di una cartella aggiugendo dei nomi all'inizio di ogni file

if [[ $# == 0 ]]; then
	echo "troppi pochi parametri"
	exit 1
fi
if [[ ! -d "$1" ]]; then
	echo "la directory non esiste"
	exit 1
fi
# entrai i parametri non devono avere '/' come carattere finale
lastCharFirstParameter=${1:0-1}
if [[ $lastCharFirstParameter = '/' ]]; then
  echo "a directory must not end with '/' character" 
  exit 1
fi


i=1
find "$1" -type f -name "*.mp3" | while read -r file
do
    onlyName=`echo $file | rev | cut -d "/" -f1 | rev`
    onlyDirs=`echo $file | rev | cut -d "/" -f2- | rev`
    # cerca il metadato "Artista" nel file (se c'è più di un artista prende solo il primo)
	artist=$(exiftool "$file" | grep "Artist " | cut -d : -f 2 | sed "s/ //" | cut -d "/" -f1)

	if [[ $i -le 9 ]]; then
		# !!!
		newName="0$i - $artist - ${onlyName}"
		#newName="0$i - ${file}"
	else 
		# !!!
		newName="$i - $artist - ${onlyName}"
		#newName="$i - ${file}"
	fi

	# !!!
	mv "$file" "$onlyDirs/$newName"
	echo "mv "$file" "$onlyDirs/$newName""
    
	i=$((i + 1))
done
