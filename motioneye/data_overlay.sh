#!/bin/sh
CAM_CONFIG_FILE="/etc/motioneye/camera-1.conf"
CAM_NAME=''
if [ -f $CAM_CONFIG_FILE ]; then
	CAM_NAME=`grep text_left $CAM_CONFIG_FILE | cut -f2 -d' '`
fi
TEMP=`vcgencmd measure_temp | cut -f2 -d'='`
VOLT=`vcgencmd measure_volts | cut -f2 -d'='`
SPEED=`vcgencmd measure_clock arm | cut -f2 -d'='`
LEN=`expr length $SPEED`
SPEED=`echo $SPEED | cut -c 1-$(($LEN-6))`
#SPEED=${SPEED%%"000"}
LOAD=`uptime | cut -f3- -d, | cut -f2 -d:`

WIFISPEED=`sudo iwconfig wlan0 | grep "Bit Rate" | cut -f2 -d'=' | cut -f1 -d'T'`
WIFISIGNAL=`sudo iwconfig wlan0 | grep "Signal" | cut -f3 -d'='`

###########################
#
OTHERDATA=""
if [ -f "/etc/motioneye/temp_hum.py" ]; then
        SENSOR=`python3 /etc/motioneye/temp_hum.py | grep "Temp"`
	OTHERDATA=$SENSOR
	#SENSORT=`echo $SENSOR | grep "*C"`
        #SENSORH=`echo $SENSOR | grep "Hum"`
        #OTHERDATA=$SENSORT$SENSORH
fi

#OTHERDATA="\n Temp: xx.x'C\n  Hum: xx.x\n   pH: xx.x\n  CO2: xx\n   O2: xx"
#
###########################

#CPU="$CAM_NAME\%20$TEMP\%20$VOLT\%20$SPEED\MHz"
CPU="$CAM_NAME\%20$TEMP\%20Load$LOAD"
WIFI="WiFi:  $WIFISIGNAL\%20$WIFISPEED"
echo "$OTHERDATA\n$CPU\n$WIFI"
#echo "$CPU\n$WIFI"

curl "http://localhost:7999/1/config/set?text_left=$OTHERDATA\n$CPU\n$WIFI"
#curl "http://localhost:7999/1/config/set?text_left=$CAM_NAME\%20$TEMP$OTHERDATA"

