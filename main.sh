#!/bin/bash
list=($(iw dev | awk '$1=="Interface"{print $2}'))
let i=0 # define counting variable
W=() # define working array
while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
done < <(iw dev | awk '$1=="Interface"{print $2}')
FILE=$(dialog --title "List of adapters" --menu "Chose one" 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3) # show dialog and store output
clear
if [ $? -eq 0 ]; then # Exit with OK
    FILE=$((FILE-1))
    adapter=${list[$FILE]}
    sudo airmon-ng start $adapter
    adapter=$(iw dev | awk '$1=="Interface"{print $2}' | grep "mon")
    sudo airodump-ng $adapter -w /home/pi/wifi/all
fi

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Циклон"
TITLE="Циклон Wi-Fi"
MENU="Виберіть пункт:"

OPTIONS=(1 "Моніторинг точки"
         2 "Моніторинг ефіру"
         3 "Завершення роботи")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            sudo ./ap_mon.sh
            ;;
        2)
            tmp=$(date +%Y%m%d_%H%M%S)_"all"
            sudo mkdir $tmp   
            sudo mv all* $tmp/
	    sudo ./reverse.sh
            ;;
        3)
            sudo airmon-ng stop $adapter"mon"
	    tmp=$(date +%Y%m%d_%H%M%S)_"all"
	    sudo mkdir $tmp
	    sudo mv all* $tmp/
            ;;
esac

