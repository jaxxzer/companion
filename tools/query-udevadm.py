#!/usr/bin/env python3

'''
Print a json with information about usb/udev devices. The devices are selected using
an input --pattern. This program will return a json describing the usb devices according 
to the command `udevadm info <device>`. Information is collected for each udev device 
matching the input pattern.

ex. `python3 query-udevadm.py --pattern=/dev/video*`
`python3 query-udevadm.py --pattern=/dev/disk/by-id/* --indent=2`

The patterns are matched according to the python glob module. This only provides support 
for simple unix style patterns.

See also, for example, (or similar):
`udevadm info /dev/sda | sed -n 's/E: //p'`

The json format is:
{
    "devices":[
            {
                "path":<pattern match path>
                "companionDevice": <known/expected devices in companion>
                "udevInfo":{
                    <udev-attr>:<udev-value>,
                    ...
                }
            },
            ... 
        ]
    }
}
'''

# TODO should we generally move os to subprocess in companion?
# TODO python2 support
import sys
import subprocess
import glob
import argparse
import json
import re

PARSER = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
PARSER.add_argument('--pattern',
                    action="store",
                    type=str,
                    default="/dev/serial/by-id/*",
                    help="Path to search for usb devices."
                    )
PARSER.add_argument('--indent',
                    action="store",
                    type=int,
                    default=None,
                    help="Indent level for json output formatting."
                    )
ARGS = PARSER.parse_args()

companionFamiliarDevices = {
    "Pixhawk Autopilot":
    {
        "ID_MODEL" : "PX4_FMU_v2.x",
        "ID_SERIAL" : "3D_Robotics_PX4_FMU_v2.x_0"
    },
    "Pixhawk Autopilot Bootloader":
    {
        "ID_MODEL" : 'PX4_BL_FMU_v2.x',
        "ID_SERIAL" : "3D_Robotics_PX4_BL_FMU_v2.x_0"
    },
    "Blue Robotics HD Low Light USB Camera":
    {
        "ID_VENDOR_ID" : "05a3",
        "ID_MODEL_ID" : "9422"
    },
    "Raspberry Pi Camera Module":
    {
        "ID_V4L_PRODUCT" : "mmal service 16.1",
        "COLORD_KIND" : "camera"
    },
    "Logitech c920 Camera":
    {
        "ID_MODEL_ID" : "082d",
        "ID_VENDOR_ID" : "046d"
    }
}

ret = {
    "devices":[]
}

regexString = ".*: (.*)=(.*)"

def getUdevInfo(devicePath):
    try:
        output = subprocess.check_output(
            ["udevadm", "info", devicePath],
            stderr = subprocess.DEVNULL, # don't print stderr in output
            universal_newlines=True) # needed for the output to be a string?

    except subprocess.CalledProcessError as e:
        if e.returncode is 4:
            print("no udevadm info for %s" % devicePath, file=sys.stderr)
            return {}
        else:
            raise e

    ret = {}
    regex = re.compile(regexString)
    matches = regex.findall(output)

    for match in matches:
        ret[match[0]] = match[1]

    return ret

# get list of filesystem paths matching pattern
# ie /dev/ttyACM* -> [ '/dev/ttyACM0', '/dev/ttyACM1' ]
devices = glob.glob(ARGS.pattern)

# ie for each "filename" in list of filenames
# ex for each device in /dev/serial/by-id/
for device in devices:
    # no match for input search pattern
    if not len(device):
        continue

    deviceInfo = {}
    udevInfo = getUdevInfo(device)

    # nothing of interest
    if not len(udevInfo):
        continue

    # the path matching the input pattern for this device
    deviceInfo["path"] = device

    # udev attributes
    deviceInfo["udevInfo"] = udevInfo
    
    # search for known device attributes from list of known devices
    for familiarDevice in companionFamiliarDevices:
        match = True
        # list of identifying udev attributes for this device
        for identifier in companionFamiliarDevices[familiarDevice]:
            try:
                # see if this device has the attribute/value we are looking for
                if udevInfo[identifier] != companionFamiliarDevices[familiarDevice][identifier]:
                    match = False
                    break # all identifiers must match
            except KeyError as e:
                match = False
                break # all identifiers must match
        if match:
            deviceInfo["companionDevice"] = familiarDevice # all identifiers match, we know this device
            break # we know what device this is, we don't need to check any further

    ret["devices"].append(deviceInfo)

print(json.dumps(ret, indent = ARGS.indent))
