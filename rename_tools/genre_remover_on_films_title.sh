#!/bin/bash
# "ANIMAZIONE 2011 (08) - rango.mp4" => "rango (2011).mp4"

find $1 -type f -exec basename {} \; | while read -r file
do
    year=`echo $file | cut -d "(" -f1 | rev`
    year=${year:0:5}
    year=`echo $year | rev`

    title_and_extension=`echo $file | cut -d "-" -f2- | tr "A-Z" "a-z"`
    title=`echo $title_and_extension | rev | cut -d. -f2- | rev`
    extension=`echo $title_and_extension | rev | cut -d. -f1 | rev`

    echo "$title ($year).$extension"
    #mv "$1/$file" "$1/$title ($year).$extension"
done | sort
