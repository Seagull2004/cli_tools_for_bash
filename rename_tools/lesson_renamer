# !/bin/bash
# script per convertire il nome di un file
# "Lezione XX - dd.mm.YYYY.md" -> "YYYYmmdd.md"


cd "$1"
pwd
echo $#
if [[ $# -ne 0 || "$1" == "" ]]; then
	echo "ASSICURARSI DI AVER SCRITTO CORRETTAMENTE IL PERCORSO ALLA CARTELLA"
	exit
fi


echo "gg"
pwd
exit

for file in Lezione*; do
	estensione=${file##*.}

    	giorno=$(echo "$file" | cut -d ' ' -f4 | cut -d '.' -f1)
    	if (($giorno <= 9)); then
    	        giorno=0$giorno
    	fi

    	mese=$(echo "$file" | cut -d '-' -f2 | cut -d '.' -f2)
    	if (($mese <= 9)); then
    	        mese=0$mese
    	fi

    	anno=$(echo "$file" | cut -d '-' -f2 | cut -d '.' -f3)

    	
	nuovo_nome="$anno$mese${giorno}0930.$estensione"
    	echo "$file -> $nuovo_nome"

	# SCOMMENTA SOLO SE SEI SODDISFATTO DEL RISULTATO ⤵️
    	mv "$file" "$nuovo_nome"
done
