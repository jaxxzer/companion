#!/usr/bin/env python

'''
Print a json with information about screens that are running for a given user.
Most of the services offered by Blue Robotics companion are run as background
command line processes. These commands/services are running under detached 
screens. This program will return a json describing the screen ids and names
for a given user.

The json format is:
{
    "user":<username>,
    "screens": [
        {
        "idNum":<id number>,
        "idName":<id name>,
        "time":<time>,
        "state":<state>
        },
        ...
    ]
}
'''

import argparse
import subprocess
import re
import json

PARSER = argparse.ArgumentParser(description=__doc__)
PARSER.add_argument('--user',
                    action="store",
                    type=str,
                    default="root",
                    help="User to check for running screen processes."
                    )
PARSER.add_argument('--indent',
                    action="store",
                    type=int,
                    default=None,
                    help="Indent level for json output formatting."
                    )
ARGS = PARSER.parse_args()

ret = {
    "user" : ARGS.user,
    "screens" : []
}

def processScreenOutputLine(line):
    ret = {}

    fields = line.split('\t')
    id = fields[0].split('.', 1)
    ret["idNum"] = id[0]
    ret["idName"] = id[1]
    ret["time"] = fields[1]
    ret["state"] = fields[2]
    
    return ret

try:
    # -A exits w error instead of asking password
    output = subprocess.check_output(["sudo", "-Au" + ARGS.user, "screen", "-ls"], universal_newlines=True)
    regex = re.compile("[0-9]+\..*")
    lines = regex.findall(output)
    for line in lines:
        ret["screens"].append(processScreenOutputLine(line))
except subprocess.CalledProcessError as e:
    if e.returncode is 1:
        pass

print(json.dumps(ret, indent = ARGS.indent))
