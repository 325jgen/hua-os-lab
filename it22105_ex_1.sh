#!/usr/bin/env bash
# The number of parameters taken from the terminal is given from the this --> $#

# If parameters passed are more than 0, print usage of script and exit. Only continues if ./it22105_ex_1.sh is used
if [ $# -gt 0 ]
then
    echo "Usage: $0"
    exit
fi

# Check if file exists, if it does not create the file at the $hd_size_file path
hd_size_file=~/.hd_size
if ! [ -f "$hd_size_file" ]
then
    touch $hd_size_file
fi

# Echo output of $date to $hd_size_file
date=$(date 2> /dev/null)
echo $date >> $hd_size_file

# Echo output of $size_of_home to $hd_size_file
size_of_home=$(du ~/ -h | tail -1 2> /dev/null)
echo -e "$size_of_home\n************" >> $hd_size_file
