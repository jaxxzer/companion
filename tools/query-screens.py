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
        "state":<state>
        },
        ...
    ]
}

To create a detached screen, use `-dm`:
`screen -dm`

To create a named screen, use `-S`:
`screen -dm -S <screenName>`
ex `screen -dm -S myScreen`

To list the currently running screen sessions, use:
`screen -ls`

To list the currently running screen sessions of a particular ie different user, use:
`sudo -u <username> screen -ls`
ex `sudo -u $(whoami) screen -ls`

To attach to a detached screen, refer to the screen using the id number or the name.
`screen -r <screenId|screenName>`
ex `screen -r myScreen`

In an attached screen session, you may press `<ctrl + a>`, then `:` to enter 'command mode'.

To detach from an attached screen session, enter command mode, and press `<d>` to detach.
To scroll in an attached screen session, enter command mode, and press `<esc>`.
Then, you may scroll. To resume following the most recent output, press `<esc>` again.

To issue a command on a detached screen, use `-X` and the command you want to enter, `quit`:
`screen -S <screenName> -X <command>`
ex `screen -S myScreen -X quit`

To exit (terminate) an attached screen session, enter command mode, and type `quit`, 
then press `<enter>`.

See `man screen` for more information.
'''

import argparse
import subprocess
import re
import json

PARSER = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
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

# process line of interest (regex match) from output of `screen -ls` command
# ex:
# $ screen -ls
# There are screens on:
#     3669.myScreen      (Detached)
def processScreenOutputLine(line):
    ret = {}

    fields = line.split('\t')
    id = fields[0].split('.', 1)
    ret["idNum"] = id[0]
    ret["idName"] = id[1]
    ret["state"] = fields[-1]
    
    return ret

output = ""
try:
    # -A exits w error instead of asking password
    output = subprocess.check_output(["sudo", "-Au" + ARGS.user, "screen", "-ls"], universal_newlines=True)

except subprocess.CalledProcessError as e:
    if e.returncode is 1:
        output = e.output # screen v4.2.x always gives exit code of 1 for 'screen -ls'

finally:
    # match 1~many digits, followed by one dot '.' character, then whatever follows until we hit a newline
    regex = re.compile("[0-9]+\..*")
    lines = regex.findall(output)
    for line in lines:
        ret["screens"].append(processScreenOutputLine(line))

print(json.dumps(ret, indent = ARGS.indent))