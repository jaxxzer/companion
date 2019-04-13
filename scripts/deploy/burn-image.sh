#!/usr/bin/env bash

# This script is intended to burn a companion image file to an SD card
# The image may be a zipped image file of the same name, (in the current directory TODO fix)
#
# The image can optionally be adjusted to NOT expand the file system at first boot
# It will accomplish this by removing the line /home/pi/companion/scripts/expand_fs.sh
# from the file /etc/rc.local
#
# This script will need root privleges
#
# usage: ./burn-image.sh IMAGEFILE DISK [noexpand]

IMAGE_FILE=$1
DEV_DISK=$2

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

# make sure we have first argument
if [[ $IMAGE_FILE == "" ]]; then
    echo "usage: ./burn-image.sh IMAGEFILE DISK [noexpand]"
    error "no image argument supplied"
fi

# make sure we have second argument
if [[ $DEV_DISK == "" ]]; then
    echo "usage: ./burn-image.sh IMAGEFILE DISK [noexpand]"
    error "no disk argument supplied"
fi

# check if we have third argument
if [[ $3 != "noexpand" && $3 != "" ]]; then
    echo "usage: ./burn-image.sh IMAGEFILE DISK [noexpand]"
    error "unrecognized argument $3"
fi

# make sure we do not have too many arguments
if [[ $4 != "" ]]; then
    echo "usage: ./burn-image.sh IMAGEFILE DISK [noexpand]"
    error "too many arguments supplied"
fi

# make sure the disk is on usb (it must be, in order to protect
# internal hard drive from accidents)
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
echo "Are you sure you want to burn $IMAGE_FILE to $DEV_DISK?"
echo "$DEV_DISK is $DEV_DISK_SIZE"
input "y"

echo "Are you sure you're sure?"
echo "This will PERMANENTLY ERASE the contents of $DEV_DISK"
input "y"

echo "unmounting $DEV_DISK"
umount $DEV_DISK?* || error "Failed to unmount $DEV_DISK"

echo $IMAGE_FILE | grep -q .zip

if [[ $? == 0 ]]; then
    echo "extracting image..."
    IMAGE_FILE_EXTRACTED=$(echo $IMAGE_FILE | sed "s/.zip//")
    unzip $IMAGE_FILE || error "Failed to unzip $IMAGE_FILE"
    IMAGE_FILE=$IMAGE_FILE_EXTRACTED
fi

# copy the image, print progress
echo "burning $IMAGE_FILE to $DEV_DISK..."
dd if=$IMAGE_FILE of=$DEV_DISK bs=1MiB status=progress || error "Failed to copy $IMAGE_FILE to $DEV_DISK"

if [[ $3 == "noexpand" ]]; then
    MOUNT_LOCATION=/tmp/companion_deploy
    echo "creating mount point $MOUNT_LOCATION"
    mkdir -p $MOUNT_LOCATION || error "Failed to create mount point $MOUNT_LOCATION"

    # The root filesystem is on partition 2
    DEV_PART2=$DEV_DISK
    DEV_PART2+=2

    echo "mounting $DEV_DISK on $MOUNT_LOCATION"
    mount $DEV_PART2 $MOUNT_LOCATION || error "Failed to mount $DEV_PART2 on $MOUNT_LOCATION"

    echo "removing expand command $EXPAND from /etc/rc.local"
    EXPAND="/home/pi/companion/scripts/expand_fs.sh"
    sed -i "\%$EXPAND%d" $MOUNT_LOCATION/etc/rc.local || error "Failed to remove expand command '$EXPAND'"

    echo "unmounting $DEV_DISK"
    umount $DEV_DISK?* || error "Failed to unmount $DEV_DISK"
fi

echo "done"
