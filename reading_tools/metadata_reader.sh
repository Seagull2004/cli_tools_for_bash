# !/bin/bash
# Ecco come leggere dei metadati da dei file usando il comando exiftool

cd "/Users/macpro/Music/playlist/eternal sunshine/"

for file in * 
do
	artist=$(exiftool "$file" | grep "Artist " | cut -d : -f 2 | sed "s/ //")
	album=$(exiftool "$file" | grep "Album " | cut -d : -f 2 | sed "s/ //")
	genre=$(exiftool "$file" | grep "Genre " | cut -d : -f 2 | sed "s/ //")
	
	echo "file: $file"
	echo "artist: $artist"
	echo "album: $album"
	echo "genre: $genre"
	echo "==========================="
done

