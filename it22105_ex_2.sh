#!/usr/bin/env bash

declare -r tmp=".tmp"

if [ $# -ne 2 ]
then
    echo -e "Usage: $0 direcotry-name file-size"
    exit
fi

dir=$1
file_size=$2

# Checking if first parameter is a directory
if ! [ -d "$dir" ] 
then
    echo -e "$dir is not a directory."
    exit
fi

# for find: -size n[c --> bytes, w --> two-byte words, k --> kilobytes, M --> megabytes, G --> gigabytes]

# Checking if 2nd parameter is a size that exists
# if ! [[  ]] 

find "$dir" -type f -size +"$file_size" -exec ls -lh {} + 2> /dev/null > $tmp

while IFS= read -r line
do
    size=$(echo "$line" | cut -d " " -f 5)
    printf '%s\n' "$size"

    path=$(echo "$line" | cut -d " " -f 10-)
    
    # THe read in the while line is occupying the STDIN, so the rm -i command is never given the STDIN, that's why I enforce the command to address the terminal directly
    rm -i "$path" < /dev/tty
done < $tmp
