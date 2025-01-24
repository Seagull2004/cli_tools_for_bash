#!/bin/bash
FOLDER="/Users/macpro/Documents/vault/07 - ARCHIVES"

# ordinamento immagini
# find "$FOLDER" -type f | grep -e ".*\.md" | while read -r pathname; do
#   dir=`echo $pathname | rev | cut -d/ -f2- | rev`
#   file=`echo $pathname | rev | cut -d/ -f1 | rev`
#   
#   mkdir -p "$dir/img"
#   #echo "mkdir -p "$dir/img""
# 
#   cat "$dir/$file" | grep -e ".*\.png.*"| while read -r image; do
#     imageName=`echo $image | cut -d[ -f3 | cut -d "." -f1`.png
#     mv "/Users/macpro/Documents/vault/99 - META/Images/$imageName" "$dir/img"
#   done
# done


# ordinamento dei file .excalidraw.md
# find "$FOLDER" -type f | grep -e ".*\.md" | while read -r pathname; do
#   dir=`echo $pathname | rev | cut -d/ -f2- | rev`
#   file=`echo $pathname | rev | cut -d/ -f1 | rev`
#   cat "$dir/$file" | grep -e ".*\.excalidraw.*"| while read -r excalidrawLine; do
#     excalidrawFile=D`echo $excalidrawLine | cut -dD -f2- | cut -d "." -f 1-3`.excalidraw.md
#     if [[ -e "/Users/macpro/Documents/vault/99 - META/Excalidraw/$excalidrawFile" ]]; then
#       mv "/Users/macpro/Documents/vault/99 - META/Excalidraw/$excalidrawFile" "$dir"
#     fi
#   done
# done
