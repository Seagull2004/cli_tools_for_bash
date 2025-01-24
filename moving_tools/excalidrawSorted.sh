#!/bin/bash

# questo script di occupa di ordinare tutti i file excalidraw (della vault di obsidian) all'interno di una cartella apposita 
#
# e.g. 
# situazione iniziale:
# .
# ├── 202410151629.md
# ├── 202410171328.md
# ├── 202410221624.md
# ├── Drawing 2024-10-12 18.55.36.excalidraw.md
# ├── Drawing 2024-10-12 19.10.38.excalidraw.md
# ├── Drawing 2024-10-17 13.39.30.excalidraw.md
# ├── Drawing 2024-10-17 13.44.13.excalidraw.md
# ├── Drawing 2024-10-17 14.00.27.excalidraw.md
# ├── Drawing 2024-10-17 14.09.59.excalidraw.md
# ├── Drawing 2024-10-17 14.19.57.excalidraw.md
# ├── Drawing 2024-10-17 15.09.27.excalidraw.md
# ├── Drawing 2024-10-22 16.32.46.excalidraw.md
# ├── Drawing 2024-10-22 16.52.35.excalidraw.md
# ├── logica matematica 2425-1.md
# └── materiale
#     └── dispense2324 (alta leggibilità).pdf
# situazione post script:
# .
# ├── 202410151629.md
# ├── 202410171328.md
# ├── 202410221624.md
# ├── logica matematica 2425-1.md
# ├── excalidraw
# |   └── Drawing 2024-10-12 18.55.36.excalidraw.md
# |   └── Drawing 2024-10-12 19.10.38.excalidraw.md
# |   └── Drawing 2024-10-17 13.39.30.excalidraw.md
# |   └── Drawing 2024-10-17 13.44.13.excalidraw.md
# |   └── Drawing 2024-10-17 14.00.27.excalidraw.md
# |   └── Drawing 2024-10-17 14.09.59.excalidraw.md
# |   └── Drawing 2024-10-17 14.19.57.excalidraw.md
# |   └── Drawing 2024-10-17 15.09.27.excalidraw.md
# |   └── Drawing 2024-10-22 16.32.46.excalidraw.md
# |   └── Drawing 2024-10-22 16.52.35.excalidraw.md
# └── materiale
#     └── dispense2324 (alta leggibilità).pdf

VAULT="/Users/macpro/Documents/vault"
totFiles=`find "$VAULT" -name "*Drawing*excalidraw.md" | wc -l | tr -d " "`

echo -n "sorting excalidraw file... "
find "$VAULT" -name "*Drawing*excalidraw.md" | grep "/excalidraw/" -v | while read -r pathname
do
    file=`echo $pathname | rev | cut -d/ -f1 | rev`
    onlyDirPathname=`echo $pathname | rev | cut -d/ -f2- | rev`
    mkdir -p "$onlyDirPathname/excalidraw"
    mv "$pathname" "$onlyDirPathname/excalidraw"
done
echo "done!"
