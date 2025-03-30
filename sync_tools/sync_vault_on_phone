#!/bin/bash

# Configurazione
LOCAL_DIR="/Users/macpro/Documents/vault" 
REMOTE_DIR="/sdcard/Documents/vault"

# File temporanei
LOCAL_LIST=$(mktemp)
REMOTE_LIST=$(mktemp)
MISSING_FILES=$(mktemp)
EXTRA_FILES=$(mktemp)
OLD_FILES=$(mktemp)
DUMMY=$(mktemp)


# Funzione per ottenere la lista dei file locali con date di modifica
generate_file_list() {
	find "$1" -type f -print0 | xargs -0 stat -f "%N§%m" | awk -v replace="${LOCAL_DIR}/" '{gsub(replace,""); print}' | sort > "$2"
}

# Genera la lista dei file per la cartella locale e anche la lista con solo le cartelle locali
generate_file_list "$LOCAL_DIR" "$LOCAL_LIST"

# Genera la lista dei file per la cartella remota
adb shell "find '$REMOTE_DIR' -type f -printf '%P§%T@\n'" | rev | cut -d. -f 2- | rev | sort > "$REMOTE_LIST"

# con il flag ignore la cartella .obsidian viene ignorata
if [[ $1 == "ignore" ]]; then
	awk '!/\.obsidian/' "$LOCAL_LIST" > "$DUMMY"
	cat "$DUMMY" > "$LOCAL_LIST"
	awk '!/\.obsidian/' "$REMOTE_LIST" > "$DUMMY"
	cat "$DUMMY" > "$REMOTE_LIST"
fi


# Trova i file mancanti sulla cartella del telefono
# 2 = nasconde le linee che sono uniche nel file 2
# 3 = nasconde le linee che sono comuni sia a file 1 che a file 2
comm -23 <(cut -d'§' -f1 "$LOCAL_LIST") <(cut -d'§' -f1 "$REMOTE_LIST") > "$MISSING_FILES"

# Trova i file di troppo sulla cartella del telefono
# 1 = nasconde le linee che sono uniche nel file 1
# 3 = nasconde le linee che sono comuni sia a file 1 che a file 2
comm -13 <(cut -d'§' -f1 "$LOCAL_LIST") <(cut -d'§' -f1 "$REMOTE_LIST") > "$EXTRA_FILES"

# Trova i file con data di modifica più vecchia sulla cartella del telefono
while read -r line; do
  local_file=$(echo "$line" | cut -d'§' -f1)
  local_mtime=$(echo "$line" | cut -d'§' -f2)
  remote_mtime=$(grep "$local_file" "$REMOTE_LIST" | cut -d'§' -f2)

  if [[ -n "$remote_mtime" && $remote_mtime != $local_mtime ]]; then
    echo "$local_file" >> "$OLD_FILES"
  fi
done < "$LOCAL_LIST"


# Mostra i risultati
echo "=================================================================="
echo "========================= File mancanti =========================="
echo "=================================================================="
cat "$MISSING_FILES"
echo ""

echo "=================================================================="
echo "========================= File di troppo ========================="
echo "=================================================================="
cat "$EXTRA_FILES"
echo ""

echo "=================================================================="
echo "======================= File da aggiornare  ======================"
echo "=================================================================="
cat "$OLD_FILES"
echo ""


echo "=================================================================="
echo "======================= sincronizzazione... ======================"
echo "=================================================================="


# Procede a sincronizzare
# 1. aggiungi file mancanti
# while read -r line; do
# 	fileDaAggiungere=${LOCAL_DIR}/${line}
# 	cartellaDiDestinazione=$(echo "${REMOTE_DIR}/${line}" | rev | cut -d"/" -f 2- | rev)
# 	adb shell "mkdir -p '$cartellaDiDestinazione'"
# 	adb push "$fileDaAggiungere" "$cartellaDiDestinazione"
# done < "$MISSING_FILES"
# nFileMancanti=$(awk 'END{print NR}' "$MISSING_FILES")
# echo "- Eventuali file mancanti sono stati aggiunti correttamente ($nFileMancanti)"
# ---
mkdirCommands=""
pushCommands=""
while read -r line; do
	fileDaAggiungere="${LOCAL_DIR}/${line}"
	cartellaDiDestinazione=$(echo "${REMOTE_DIR}/${line}" | rev | cut -d"/" -f 2- | rev)
	mkdirCommands="$mkdirCommands mkdir -p '$cartellaDiDestinazione';"
	pushCommands="$pushCommands adb push '$fileDaAggiungere' '$cartellaDiDestinazione';"
done < "$MISSING_FILES"

if [ -n "$mkdirCommands" ]; then
	adb shell "$mkdirCommands"
fi
if [ -n "$pushCommands" ]; then
	eval "$pushCommands"
fi

nFileMancanti=$(awk 'END{print NR}' "$MISSING_FILES")
echo "- Eventuali file mancanti sono stati aggiunti correttamente ($nFileMancanti)"


# 2. cancella i file di troppo sul telefono
# while  read -r line; do
# 	fileDaRimuovere=${REMOTE_DIR}/${line}
# 	adb shell "rm '$fileDaRimuovere'"
# done < "$EXTRA_FILES"
# nFileExtra=$(awk 'END{print NR}' "$EXTRA_FILES")
# echo "- Eventuali file in eccesso sono stati rimossi correttamente ($nFileExtra)"
# ---
filesToRemove=""
while read -r line; do
    fileDaRimuovere="${REMOTE_DIR}/${line}"
    filesToRemove="$filesToRemove '$fileDaRimuovere'"
done < "$EXTRA_FILES"

if [ -n "$filesToRemove" ]; then
    adb shell "rm $filesToRemove"
fi

nFileExtra=$(awk 'END{print NR}' "$EXTRA_FILES")
echo "- Eventuali file in eccesso sono stati rimossi correttamente ($nFileExtra)"


# 3. file da aggiornare
while  read -r line; do
	fileDaRimuovere=${REMOTE_DIR}/${line}
	adb shell "rm '$fileDaRimuovere'"
done < "$OLD_FILES"
while read -r line; do
	fileDaAggiungere=${LOCAL_DIR}/${line}
	cartellaDiDestinazione=$(echo "${REMOTE_DIR}/${line}" | rev | cut -d"/" -f 2- | rev)
	adb push "$fileDaAggiungere" "$cartellaDiDestinazione"
done < "$OLD_FILES"
nFileVecchi=$(awk 'END{print NR}' "$OLD_FILES")
echo "- Eventuali file che neccessitavano l'aggiornamento sono stati aggiornati ($nFileVecchi)"

# Pulizia
rm "$LOCAL_LIST" "$REMOTE_LIST" "$MISSING_FILES" "$EXTRA_FILES" "$OLD_FILES" "$DUMMY"
