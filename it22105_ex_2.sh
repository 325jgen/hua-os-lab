#!/usr/bin/env bash

declare -r tmp=".tmp"

function del_tmp {
    rm -rf $tmp
}

trap "del_tmp" EXIT SIGQUIT SIGKILL SIGTERM

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

# Checking if 2nd parameter is a size that exists
# pattern looks for atleast one digit and up, after that will look for
pattern='[[:digit:]]+[bcwkMG]'
if ! [[ $2 =~ $pattern ]] 
then
    echo -e "Error: file-size input was incorrect. Correct input is in this format: n[cwbkMG]\n
    \t n\tfor units of space\n
    \t'b'\tfor 512-byte blocks (default)\n
    \t'c'\tfor bytes\n
    \t'w'\tfor two-byte words\n
    \t'k'\tfor kilobytes\n
    \t'M'\tfor megabytes\n
    \t'G'\tfor gigabytes"
    exit
fi

find "$dir" -type f -size +"$file_size" -exec ls -lh {} + 2> /dev/null > $tmp

while IFS= read -r line
do
    size=$(echo "$line" | awk '{print $5}')
    printf '%s\n' "Size of file: $size"

    path=$(echo "$line" | awk '{print $9}')
    printf '%s\n' "Path of file: $path"
    
    # THe read in the while line is occupying the STDIN, so the rm -i command is never given the STDIN, that's why I enforce the command to address the terminal directly
    rm -i "$path" < /dev/tty
done < $tmp