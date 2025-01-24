# !/bin/bash
# Questo dannato script si occupa di sostituire tutte le occorrenze di percordi in stile Unix
# tipo: /Volumes/home/percorso/di/qualcosa
# in percordi stile windows
# tipo: \NAS\home\
# qualora questo percorso sia presente all'intero di un tag
# (utile per capire come usare il potentissimo comando awk)

file_name="./videodb.xml"
exit

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
