#!/bin/bash

# CoralCam.sh

# Author: Jack Butler
# Created: March 2020
# Last Edit:
# Edit Comments:

# CoralCam takes 5 images, 4 times per day. This script schedules the on/off sequence, 
# takes the images and stores them, and shutdowns the camera

clear
echo "--------------------------------------------------------------------------------"
echo "|"
echo "|"
echo "|		Welcome to CoralCam"
echo "|"
echo "|"
echo "----------------$(date)-------------------------"


# -----------------------------------------------------------------------
# Set up
# -----------------------------------------------------------------------

rf="run.log"

start=$(date)
hour=$(date +%H)

echo "" |& tee -a "${rf}"
echo "Start time of CoralCam.sh: $start" |& tee -a "${rf}"

# -----------------------------------------------------------------------
# Schedule next start-up
# -----------------------------------------------------------------------
echo "Scheduling next start-up..." |& tee -a "${rf}"

sudo /home/pi//wittypi/runScript.sh |& tee -a "${rf}"

# -----------------------------------------------------------------------
# Turn on lights
# -----------------------------------------------------------------------

gpio mode 25 out
gpio write 25 1

sleep 120s

gpio write 25 0
	
# -----------------------------------------------------------------------
# Take images
# -----------------------------------------------------------------------
cd /media/DATA

cnt=1

while [ $cnt -lt 6 ]; do

fname=$(date +"%Y-%m-%d_%H%M%S")
raspistill -vf -hf --raw -o $fname.jpg

sleep 30s
cnt++

done

cd /home/pi

# -----------------------------------------------------------------------
# Check temperature
# -----------------------------------------------------------------------
. /home/pi/wittyPi/utilities.sh

cd /home/pi/wittyPi && temp="$(get_temperature)"
cd /home/pi && echo "wittyPi temperature at $(date +%T) is $temp" |& tee -a "${rf}"

# -----------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------
echo "End time of CoralCam.sh: $(date +%T)" |& tee -a "${rf}"

# -----------------------------------------------------------------------
# Exit CoralCam
# -----------------------------------------------------------------------
echo "Exiting CoralCam.sh..."
exit 0

