# !/bin/bash

if [[ $# -ne 2 ]]; then
	# check this out to understand what does this program
	echo "description: this program allow you to check if a given directory contains all the files that are in another direcory"
	echo "usage: ./check_presence_of_files [dir1] [dir2]"
	echo "- [dir1] the bigger directory that scould contain all the files"
	echo "- [dir2] the smaller direcory that will hopefully have all files that are already present in dir1"
	exit
fi

# d1 sarà la cartella più grossa
d1=$1
# d2 sarà la cartella più piccola
d2=$2

# formattazione richiesta: 
# xxx - nomeArtista - titoloCanzone.mp3

# in two different files I'll save the list of name of all file that are store in the two directory
ls "$d1" | cut -d - -f 3- | sed 's/ //' > list1.txt
ls "$d2" | cut -d - -f 3- | sed 's/ //' > list2.txt

list1="list1.txt"
list2="list2.txt"

list1Len=$(wc -l < "$list1")
list2Len=$(wc -l < "$list2")

for ((i = 1; i <= $list2Len; i++)); do
	row=$(head -"$i" "$list2" | tail -1)
	echo -n "new song: $row searching... "
	isPresent=0
	for ((j = 1; j <= $list1Len; j++)); do
		row2=$(head -"$j" "$list1" | tail -1)
		if [[ "$row" == "$row2" ]]; then
			isPresent=1
			continue
		fi
	done
	if [[ $isPresent -eq 1 ]]; then
		echo "✅"	
	else
		echo "❌"
	fi

done

rm $list1
rm $list2
