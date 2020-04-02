#! /bin/bash

# installCoralCam.sh

# Author: Jack Butler
# Created: March 2020
# Last Edit: J Butler March 2020

# Installs CoralCam dependencies, shell scripts, and configs

# ----------------------------------------------------------
# Check whether git and fbi are installed
# ----------------------------------------------------------
git --version
if [ $? -ne 0 ]; then
	echo "Git is not installed. Please install git, reboot and try again."
	echo "Exiting TrapCam install..."
	exit 1
fi

fbi --version
if [ $? -ne 0 ]; then
	echo "fbi package is not currently installed."
	echo "Installing fbi package now..."
	apt update
	echo "y" | apt install fbi
fi

# ----------------------------------------------------------
# Install CoralCam Software
# ----------------------------------------------------------
clear
echo "--------------------------------------------------------------------------------"
echo "|"
echo "|"
echo "| 	Installing CoralCam software"
echo "|"
echo "|"
echo "--------------------------------------------------------------------------------"

cd /home/
WD=/home/pi
cd $WD

# ----------------------------------------------------------
# Copy configs
# ----------------------------------------------------------
echo "Copying config files. Previous cmdline, config, bashrc, and rclocal files are stored as .old"

cp /boot/cmdline.txt /boot/cmdline.txt.old
echo "$(cat /boot/cmdline.txt) logo.nologo quiet splash loglevel=0" > /boot/cmdline.txt
cp /boot/config.txt /boot/config.txt.old
cp $WD/CoralCam/configs/config.txt /boot/

cp .bashrc .bashrc.old
cp $WD/CoralCam/configs/.bashrc .

cp /etc/rc.local /etc/rc.local.old
cp $WD/CoralCam/configs/rc.local /etc/

echo "Done copying configs"

# ----------------------------------------------------------
# Copy and install services
# ----------------------------------------------------------
echo "Copying and installing services..."

cp /etc/systemd/system/autologin@.service /etc/systemd/system/autologin@.service.old
cp $WD/CoralCam/services/autologin@.service /etc/systemd/system/

cp $WD/CoralCam/services/image_on_shutdown.service /etc/systemd/system/
cp $WD/CoralCam/services/splashscreen.service /etc/systemd/system/

systemctl enable splashscreen.service
systemctl start splashscreen.service

systemctl enable image_on_shutdown.service
systemctl start image_on_shutdown.service

cd ..

echo "Done creating boot and shutdown services"

# ----------------------------------------------------------
# Copy schedule scripts
# ----------------------------------------------------------
echo "Copying wittyPi schedule scripts..."

cd $WD/wittypi/schedules

cp $WD/CoralCam/schedules/* .
cp $WD/CoralCam/schedules/CoralCam_duty_cycle.wpi ../schedule.wpi

cd $WD

echo "Done copying schedules..."

# ----------------------------------------------------------
# Copy shell scripts
# ----------------------------------------------------------
echo "Copying CoralCam shell scripts..."

cp $WD/CoralCam/scripts/CoralCam.sh .
chmod +x CoralCam.sh

echo "Done"

# ----------------------------------------------------------
# Copy splashscreen image
# ----------------------------------------------------------
cp $WD/CoralCam/splash.png /etc/

# ----------------------------------------------------------
# Make data mount location
# ----------------------------------------------------------
echo "Creating USB mount directory..."
cd /media

if [ ! -d "DATA" ]; then
	mkdir DATA
	chown -R pi:pi /media/DATA
else
	echo "Mount directory already exists"
fi

# ----------------------------------------------------------
# Finish install
# ----------------------------------------------------------
cd $WD
echo "-------------------------------------------------------------------------------"
echo ""
echo "CoralCam software has been installed and will start upon reboot"
echo ""
echo "-------------------------------------------------------------------------------"

exit 0
