#!/bin/bash
IFS=$'\n'
set -e


### Global Variables
######### BAckup Dir
backup=/var/www/html/cacti/killspikealt/backup
######### Log file
log=/var/www/html/cacti/killspikealt/logs/spike.log
######### Date Var
datafim=$(date +%d%m%Y-%H:%M)

# File validation .rrd
if [[ $1 != *.rrd ]]
then
        echo 'The file has to be an .rrd'
        exit 1
fi

# Erase the files before runing the script
if [ -f dump.xml ] || [ -f 1.txt ] || [ -f 2.txt ] || [ -f 3.txt ]
then
        rm -rf dump.xml 1.txt 2.txt 3.txt
fi

# The file exists ?
if [ ! -f "$1" ]
then
        echo "$1 Does not exist."
        exit 1
fi

# Dumping the rrd to xml
rrdtool dump $1 dump.xml

# Show values from the xml to 1 .txt
cat dump.xml | awk '{print$8}' | awk -F'>' '{print$3}' | awk -F'<' '{print$1}' | grep -v "NaN" | sort -u > 1.txt

echo '' > 2.txt

# Scientific Notation Calc of every values in 1.txt and saves in 2.txt
count=0
while read -r line;
do
        a=$(printf %.10f $line)
        #count=$((count + 1))
        echo "$a-$line" >> 2.txt
done < 1.txt
#clear
last_v=$(sort -n -u 2.txt | tail > 3.txt )
cat 3.txt
echo
value=$(cat 3.txt | tail -n 1 | awk -F'-' '{print$2}')

echo $value

#Validadtion Regex of the value
value_reg='^[0-9]{1}\.[0-9]{10}\w\+[0-9][0-9]'
if [[ ! $value =~ $value_reg ]]
then
        echo "The value "$value" Inserted ins not ok" >> $log
        echo $value
        exit 1
fi
# $value Replace all $values with NaN
sed -i -e "s/$value/NaN/g" dump.xml

#Mv original file to .bkp and restore the dump.xml with the new NaN Values
mv $1 "${1}.$datafim"
mv "${1}.$datafim" $backup
rrdtool restore dump.xml $1
chmod -R 777 $1
chown -R apache:apache $1
#clear
echo 'Removing tmp files, 1.txt, 2.txt, 3.txt  dump_teste.xml'
rm -rf dump.xml 1.txt 2.txt 3.txt > /dev/null 2>&1
echo "All ready, The value $value has ben erased, Thank you !!!"
# Write to the .log
echo "Spike removed: $value , $datafim, $1" >> $log

exit 1