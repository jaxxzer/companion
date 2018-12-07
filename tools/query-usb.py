#!/usr/bin/env python

'''
Print a json with information about screens that are running for a given user.
Most of the services offered by Blue Robotics companion are run as background
command line processes. These commands/services are running under detached 
screens. This program will return a json describing the screen ids and names
for a given user.

The json format is:
{
    "devices":[
            {
                "path":</dev path>
                "serial-id":</by-id name>
                "usb-desc":<usb vid/pid>
                "companion-device": <known/expected devices in companion>
            },
            ... 
        ]
    }
}
'''

# TODO we should move os to subprocess in companion
import subprocess
import argparse

full = True

ret = {
    "devices":[]
}

print(ret)

_DEVPATH = "/dev/serial/by-id"



devices = ret["devices"]
devices.append({"whatsup":134})
print(ret["devices"])

# subprocess.call("udevadm info /dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00")
# subprocess.call(["udevadm", "info", "/dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00"])
output = subprocess.check_output(["udevadm", "info", "/dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00"])
print(output)
asdf = output.split(b'\n')
print(asdf)



'''
[jacob@jacob-laptop ~]$ udevadm info /dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00  | grep ID_VENDOR_ID | cut -f1 -d=
E: ID_VENDOR_ID
[jacob@jacob-laptop ~]$ udevadm info /dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00  | grep ID_VENDOR_ID | cut -f2 -d=
26ac
[jacob@jacob-laptop ~]$ udevadm info /dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00  | grep DEVNAME | cut -f2 -d=
/dev/ttyACM0


[jacob@jacob-laptop tools]$ udevadm info /dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00 | sed -n 's/E: //p'
DEVLINKS=/dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00 /dev/serial/by-path/pci-0000:00:14.0-usb-0:1:1.0
DEVNAME=/dev/ttyACM0
DEVPATH=/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/tty/ttyACM0
ID_BUS=usb
ID_MM_CANDIDATE=1
ID_MODEL=PX4_FMU_v2.x
ID_MODEL_ENC=PX4\x20FMU\x20v2.x
ID_MODEL_FROM_DATABASE=8 Series USB xHCI HC
ID_MODEL_ID=0011
ID_PATH=pci-0000:00:14.0-usb-0:1:1.0
ID_PATH_TAG=pci-0000_00_14_0-usb-0_1_1_0
ID_PCI_CLASS_FROM_DATABASE=Serial bus controller
ID_PCI_INTERFACE_FROM_DATABASE=XHCI
ID_PCI_SUBCLASS_FROM_DATABASE=USB controller
ID_REVISION=0101
ID_SERIAL=3D_Robotics_PX4_FMU_v2.x_0
ID_SERIAL_SHORT=0
ID_TYPE=generic
ID_USB_CLASS_FROM_DATABASE=Communications
ID_USB_DRIVER=cdc_acm
ID_USB_INTERFACES=:020201:0a0000:
ID_USB_INTERFACE_NUM=00
ID_VENDOR=3D_Robotics
ID_VENDOR_ENC=3D\x20Robotics
ID_VENDOR_FROM_DATABASE=Intel Corporation
ID_VENDOR_ID=26ac
MAJOR=166
MINOR=0
SUBSYSTEM=tty
TAGS=:systemd:
USEC_INITIALIZED=19009196628
[jacob@jacob-laptop tools]$
'''