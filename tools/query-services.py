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

import argparse

PARSER = argparse.ArgumentParser(description=__doc__)
PARSER.add_argument('--user',
                    action="store",
                    type=str,
                    default="root",
                    help="User to check for running screen processes."
                    )
ARGS = PARSER.parse_args()

return = {
    "user":ARGS.user,
    "screens":{}
    }
}

print(return)