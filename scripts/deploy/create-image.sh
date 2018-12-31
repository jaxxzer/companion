#!/usr/bin/env bash

DEV_DISK=$1
IMAGE_FILE=$2

error() {
    echo -e "ERROR: $*" >&2
    exit 1
}

input() {
    read -s -n 1 key
    if [[ $key != $* ]]; then
        echo "Exiting..."
        exit 0
    fi
}

if [[ $DEV_DISK == "" ]]; then
    echo "usage: ./create-image.sh DISK IMAGEFILE"
    error "no disk argument supplied"
fi

if [[ $IMAGE_FILE == "" ]]; then
    echo "usage: ./create-image.sh DISK IMAGEFILE"
    error "no image argument supplied"
fi

if [[ $3 != "" ]]; then
    echo "usage: ./create-image.sh DISK IMAGEFILE"
    error "too many arguments supplied"
fi

# make sure the disk is on usb
udevadm info $DEV_DISK | grep ID_BUS=usb > /dev/null

if [[ $? != 0 ]]; then
    error "$DEV_DISK is not on the USB bus!"
fi

# TODO make sure the disk contains a companion OS image
# check it is top level disk device, not a partition

# check size
# TODO learn sed/perl/awk w regex
DEV_DISK_SIZE=$(parted -s $DEV_DISK unit GB print devices | grep $DEV_DISK | cut -f2 -d' ')

# make sure the user wants to work with this disk
echo "$DEV_DISK is $DEV_DISK_SIZE"
echo "Are you sure you want to make an image with $DEV_DISK?"
input "y"

MOUNT_LOCATION=/tmp/companion_deploy
mkdir -p $MOUNT_LOCATION

DEV_PART2=$DEV_DISK
DEV_PART2+=2

echo "unmounting $DEV_DISK"
umount $DEV_DISK?*

echo "mounting $DEV_DISK on $MOUNT_LOCATION"
mount $DEV_PART2 $MOUNT_LOCATION || error "Failed to mount $DEV_PART2 on $MOUNT_LOCATION"

COMPANION_HOME=$MOUNT_LOCATION
COMPANION_HOME+=/home/pi

# remove backup and log
rm -rf $COMPANION_HOME/.companion
rm -rf $COMPANION_HOME/.webui.log
rm -rf $COMPANION_HOME/.update_log

# remove any wifi information
echo "" > $MOUNT_LOCATION/etc/wpa_supplicant/wpa_supplicant.conf

# insert expand_fs command in /etc/rc.local
# above the line to start the companion services
EXPAND="/home/pi/companion/scripts/expand_fs.sh"
sed -i "\%$EXPAND%d" $MOUNT_LOCATION/etc/rc.local
sed -i "\%^. /home/pi/companion/.companion.rc%i$EXPAND" $MOUNT_LOCATION/etc/rc.local

umount $MOUNT_LOCATION

END_DATA=$(parted $DEV_DISK -sm print unit MiB | grep ext4 | cut -f3 -d: | cut -f1 -dM)

echo "The end of the data is $END_DATA MiB"
echo "Do you want to copy $END_DATA MiB from $DEV_DISK to $IMAGE_FILE?"

input "y"

dd if=$DEV_DISK of=$IMAGE_FILE bs=1MiB count=$END_DATA status=progress || error "Failed to copy $DEV_DISK to $IMAGE_FILE"

echo "Do you want to compress $IMAGE_FILE?"
input "y"

zip $IMAGE_FILE.zip $IMAGE_FILE

echo "done"
