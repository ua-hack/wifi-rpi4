#!/bin/bash
#!/bin/bash
lineNum="$(grep -n "Station" /home/pi/wifi/all-01.csv | head -n 1 | cut -d: -f1)"
lineNum="$(($lineNum-"2"))"
numbers=( $(cat  "/home/pi/wifi/all-01.csv" | sed -n 3,"$lineNum"p | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $1}') )
mac=( $(cat  "/home/pi/wifi/all-01.csv" | sed -n 3,"$lineNum"p | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $2}') )
channel=( $(cat  "/home/pi/wifi/all-01.csv" | sed -n 3,"$lineNum"p | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $3}') )
essid=( $(cat  "/home/pi/wifi/all-01.csv" | sed -n 3,"$lineNum"p | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n |  awk '{print $5}') )

let i=0 # define counting variable
W=() # define working array
while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
done < <(cat  "/home/pi/wifi/all-01.csv" | sed -n 3,"$lineNum"p | awk -F',' '{ print $1 " " $4 " " $9 " " $14}' | cat -n)
FILE=$(dialog --title "Вибір точки доступу" --menu "Chose one" 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3) # show dialog and store output
clear
if [ $? -eq 0 ]; then # Exit with OK
    FILE=$((FILE-1))
    adapter=$(iw dev | awk '$1=="Interface"{print $2}' | grep "mon")
    ess=${essid[$FILE]}
    sudo airodump-ng $adapter --bssid ${mac[$FILE]} -c ${channel[$FILE]} -w /home/pi/wifi/$ess
    sudo mkdir $ess
    sudo mv $ess* $ess/
    sudo ./come.sh
fi

