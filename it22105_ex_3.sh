#!/usr/bin/env bash

# If parameters given are more than the .sh file itself, print the usage of the script and exit
if [ $# -gt 0 ]
then
    echo -e "Usage: $0"
    exit
fi

# Find size of the root filesystem and print it (returns a number in a human readble form)
root_fs_size=$(df -h | grep -e "/\$" | awk '{print $3}')
echo -e "Root filesystem size: $root_fs_size"
# Since the human readable form of the size cannot be used to calculcate the percentage usage later in the script, we need to rerun the command without the -h flag 
root_fs_size=$(df | grep -e "/\$" | awk '{print $3}')

# Same as $root_fs_size but using du to calculcate home directory usage
home_dir_size=$(du -h $HOME | tail -1 | awk '{print $1}')
echo -e "Home directory size: $home_dir_size"
home_dir_size=$(du $HOME | tail -1 | awk '{print $1}')

# Using awk to calculcate the percentage. The `print` command prints a float with many decimal points, but thre's only the need of the integer part of it. That's why `printf` needs to be used for this. 
home_usage=$(echo "($home_dir_size/$root_fs_size)*100" | bc -l) 
echo -e "Home directory uses $home_usage% of /" 
