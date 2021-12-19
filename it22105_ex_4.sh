#!/usr/bin/env bash

if [ $# -gt 0 ]
then echo -e "Usage: $0" exit
fi

OPTION=-1

while [ $OPTION -ne 4 ]
do
    printf "1) Backup\n2) QR\n3) IP\n4) Exit\n"
    read -rp "Please select an option: " OPTION

    while [[ "$OPTION" -lt 1 ]] || [[ "$OPTION" -gt 4 ]]
    do
        printf "Input was not correct\n"
        read -rp "Please select an option: " OPTION
    done


    case $OPTION in
        1)
            # If for some reason the ~/Documents folder does not exist in the system, go back to option loop 
            if [ ! -d "$HOME/Documents" ]
            then
                echo -e "Folder Documents in the home folder does not exist."
                break
            fi

            echo -e "Creating backup..."

            # Getting date for the name of the tar.gz file
            NAME_OF_DOCUMENT=$(echo "Documents-backup-"$(date "+%d-%m-%y")".tar.gz") 

            # Compressing ~/Documents
            tar -cvzf "$NAME_OF_DOCUMENT" "$HOME/Documents" 

            # Moving tar.gz file to /tmp
            mv "$NAME_OF_DOCUMENT" "/tmp"
            ;;
        2)
            read -rp "Enter text to create a QR code of it: " QR_CODE_INPUT
            curl --silent qrcode.show -d "$QR_CODE_INPUT" > /tmp/qrfile
            ;;
        3)
            IP_ADDRESS=$(curl --silent -4 ifconfig.me) 
            printf "\nYour IP address is: %s" "$IP_ADDRESS"
            printf "\n\n"
            ;;
        4)
            printf "Exiting...\n"
            exit
            ;;
    esac
done
