#!/usr/bin/env python

'''
Print a json with information about screens that are running for a given user.
Most of the services offered by Blue Robotics companion are run as background
command line processes. These commands/services are running under detached 
screens. This program will return a json describing the screen ids and names
for a given user.

See also (or similar):
`udevadm info /dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00 | sed -n 's/E: //p'`

The json format is:
{
    "devices":[
            {
                "path":</dev path>
                "serial-id":</by-id name>
                "usb-desc":<usb vid/pid>
                "companion-device": <known/expected devices in companion>
                "udev-info":{
                    <udev-attr>:<udev-value>,
                    ...
                }
            },
            ... 
        ]
    }
}
'''

# TODO we should move os to subprocess in companion
import subprocess
import argparse

EXIT_OK = 0
EXIT_ERROR = 1
EXIT_NO_DEVICE = 2

debug = False
companionFamiliarDevices = {
    "26ac:0011": "Pixhawk 1 autopilot",
    "26ac:0011": "Blue Robotics low light USB camera",
    "0403:6015": "FT231X USB UART"
}

# args: path/pattern: (video or serial)
full = False

ret = {
    "devices":[]
}

_DEVPATH = "/dev/serial/by-id/"
def debugPrint(dbg):
    if not debug:
        return
    print(dbg)

def getUdevInfo(devicePath):
    output = subprocess.check_output(["udevadm", "info", devicePath], universal_newlines=True)
    fields = output.split('\n')
    ret = {}
    for field in fields:
        field = field[3:]

        debugPrint(field)
        kvPair = field.split('=')

        if len(kvPair) > 1:
            # print("hello", kvPair)
            ret[kvPair[0]] = kvPair[1]

            
    debugPrint(ret)
    debugPrint('\n\n\n\\n')
    return ret

#TODO handle no serial devices plugged in

try:
    output = subprocess.check_output(["ls", _DEVPATH], universal_newlines=True)
except Exception as e:
    print("Error - no devices on specified path %s" % _DEVPATH)
    exit(EXIT_NO_DEVICE)
devices = output.split('\n')
debugPrint(output)
debugPrint(devices)
#print(subprocess.check_output([checkDevicesCmd.split(' ')]))
for device in devices:
    if not len(device):
        continue
    deviceInfo = {}
    deviceInfo["udev-info"] = getUdevInfo(_DEVPATH + device)

    #deviceInfo["companion-extra"] = ''

    ret["devices"].append(deviceInfo)

print(ret)
# print()
# subprocess.call(["udevadm info /dev/serial/by"])
# devices = ret["devices"]
# devices.append({"whatsup":134})
# print(ret["devices"])

# subprocess.call("udevadm info /dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00")
# subprocess.call(["udevadm", "info", "/dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00"])


# output = subprocess.check_output(["udevadm", "info", "/dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00"])
# print(output)
# asdf = output.split(b'\n')
# print(asdf)

# output = subprocess.check_output("udevadm info /dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00".split(' '))
# print(output)
# asdf = output.split(b'\n')
# print(asdf)

# output = subprocess.check_output("udevadm info /dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00 | grep ID_VENDOR_ID".split(' '))
# print(output)
# asdf = output.split(b'\n')
# print(asdf)




