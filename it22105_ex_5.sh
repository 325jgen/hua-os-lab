#!/usr/bin/env bash

if [ $# -gt 0 ]
then
    echo -e "Usage: $0 " 
    exit
fi

# Creating a temporary file
declare -r tmp=".tmp" 

function del_tmp {
    rm -rf $tmp
}

# Cleaning temporary file
trap "del_tmp" EXIT SIGQUIT SIGKILL SIGTERM

# The following line will find how many times $USER has logged in each day in this format:
#      <times logged in> <YYYY-MM-DD>
# ex.  4 2021-10-13
last --time-format iso "$USER" | sort -k4 | awk '{print $4}' | uniq | cut -c 1-10 | tail -n +2 | uniq -c > $tmp 

# A while loop which runs for every line found in .tmp
while IFS= read -r line
do
    # Getting the number of stars to print from $line
    stars=$(echo "$line" | awk '{print $1}')
    # Printing out the date of login
    echo "$line" | awk '{print $2}'

    for (( i=0 ; i<$stars ; i++ )) 
    do
        printf "*"
    done
    printf "\n"
done < $tmp
