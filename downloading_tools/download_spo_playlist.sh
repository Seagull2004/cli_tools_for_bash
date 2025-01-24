# !/bin/bash
# L'idea è molto semplice: concatenare l'id della playlist passata come parametro in seguito alla stringa:


if [[ $1 == "" ]]; then
	echo "usage: command {spotify link}"
	exit	
fi

BASE_URL="https://yank.g3v.co.uk/playlist/"

playlist_id=$(echo $1 | rev | cut -d / -f 1 | rev)

complete_url="${BASE_URL}$playlist_id"

open "$complete_url"
