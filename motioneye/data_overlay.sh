#!/bin/sh
CAM_CONFIG_FILE="/etc/motioneye/camera-1.conf"
CAM_NAME=''
if [ -f $CAM_CONFIG_FILE ]; then
	CAM_NAME=`grep text_left $CAM_CONFIG_FILE | cut -f2 -d' '`
fi
TEMP=`vcgencmd measure_temp | cut -f2 -d'='`
VOLT=`vcgencmd measure_volts | cut -f2 -d'='`
SPEED=`vcgencmd measure_clock arm | cut -f2 -d'='`
SPEED=${SPEED%%"000000"}

WIFISPEED=`iwconfig wlan0 | grep "Bit Rate" | cut -f2 -d'=' | cut -f1 -d'T'`
WIFISIGNAL=`iwconfig wlan0 | grep "Signal" | cut -f3 -d'='`

OTHERDATA="\n Temp: xx.x'C\n  Hum: xx.x\n   pH: xx.x\n  CO2: xx\n   O2: xx"

CPU="$CAM_NAME\%20$TEMP\%20$VOLT\%20$SPEED\MHz"
WIFI="WiFi: $WIFISPEED\%20$WIFISIGNAL"
echo "$CPU\n$WIFI"

curl "http://localhost:7999/1/config/set?text_left=$CPU\n$WIFI"
#curl "http://localhost:7999/1/config/set?text_left=$CAM_NAME\%20$TEMP$OTHERDATA"

