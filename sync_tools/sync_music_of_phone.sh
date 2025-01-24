# !/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
COLOR_OFF='\033[0m'


cd "/Users/macpro/Music/playlists/"
listOfSongPlaylistsAlreadyUploaded=$(adb shell ls -l /sdcard/Music/playlists/)

for dir in * 
do
	occurrenceOfAPlaylistIntoThePhone=$(echo "$listOfSongPlaylistsAlreadyUploaded" | grep " $dir" | wc -l)
	if [[ $occurrenceOfAPlaylistIntoThePhone -eq 0 ]]; then
		echo "${GREEN}++${COLOR_OFF} $dir is missing!"
		adb push "$dir" "/sdcard/Music/playlists/$dir"
	else
		echo "${RED}==${COLOR_OFF} $dir found."
	fi
done

