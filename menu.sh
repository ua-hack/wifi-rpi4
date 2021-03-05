#!/bin/bash
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Циклон"
TITLE="Циклон Wi-Fi"
MENU="Виберіть пункт:"

OPTIONS=(1 "Деаутентифікація клієнта"
         2 "Назад до меню"
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
            sudo ./deauth.sh
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

