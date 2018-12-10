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
    "screens": {
        <screen-id>:<screen-name>,
        ... 
    }
}
'''
"[0-9]+\..*"



import argparse
import subprocess

PARSER = argparse.ArgumentParser(description=__doc__)
PARSER.add_argument('--user',
                    action="store",
                    type=str,
                    default="root",
                    help="User to check for running screen processes."
                    )
ARGS = PARSER.parse_args()


output = subprocess.check_output(["screen", "-ls"])


#//>>> a = re.compile("[0-9]+\..*")
#>>> a.findall(output)
#['3873.fuck\t(12/10/2018 01:55:22 AM)\t(Detached)', '3814.hello\t(12/10/2018 01:55:06 AM)\t(Detached)']

ret = {
    "user":ARGS.user,
    "screens":{}
}

i = 0

for line in str(output):
    print("line %d", i, line)
    i += 1

print(ret)