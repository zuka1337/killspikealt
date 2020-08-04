#!/bin/bash
IFS=$'\n'

######### Script localization
a=./spikeremovealt.sh #localização do script spikeremovealt.sh


# For to an specific dir
#for i in /home/zuka/teste/*
#do
#       $a $i
#       echo $a $i
#done

# while .txt that has all the rrd paths for looping the $a variable

while read line
do
        echo $a $line
        $a $line
done < ./php.txt


echo '' > /var/www/html/cacti/killspikealt/php.txt
