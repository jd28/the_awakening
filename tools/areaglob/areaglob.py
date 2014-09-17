#!/usr/bin/env python

import configparser
import argparse
import os
import fnmatch
import collections

parser = argparse.ArgumentParser()
parser.add_argument('-v', '--version', action='version', version='0.1')
parser.add_argument('-o', '--output', help='Output file.', default='areag.ini')
parser.add_argument('-a', '--areag', help='areag.ini directory.', default='areag')
parser.add_argument('-e', '--enter', help='OnEnter Script.', default='')
parser.add_argument('-x', '--exit', help='OnExit Script.', default='')
parser.add_argument('-b', '--heartbeat', help='OnHeartbeat Script.', default='')
parser.add_argument('-u', '--user', help='OnUserDefined Script.', default='')
parser.add_argument('file', help='Base areag.ini file.')
args = parser.parse_args()

dictionary = collections.OrderedDict()

def add_to_main_dict(fname):
    with open(fname) as f:
        config = configparser.ConfigParser()
        config.optionxform = str
        config.read(fname)
        for section in config.sections():
            if section == "ENTRIES" or section == "GENERAL":
                continue
            if section in dictionary:
                 continue

            dictionary[section] = collections.OrderedDict()
            for option in config.options(section):
                dictionary[section][option] = config.get(section, option)

if __name__ == "__main__":
    add_to_main_dict(args.file)

    for root, dirnames, filenames in os.walk(args.areag):
        for filename in fnmatch.filter(filenames, '*.ini'):
            base = os.path.basename(filename)
            add_to_main_dict(os.path.join(root, filename))

    result = configparser.ConfigParser()
    result.optionxform = str
    result.add_section('GENERAL')
    result.set('GENERAL', 'Type', 'SET')
    result.set('GENERAL', 'Version', 'V1.0')

    num_tilesets = len(dictionary.keys())
    if num_tilesets > 999:
        raise ValueError("You can't have more than 999 tilesets...")

    result.add_section('ENTRIES')
    result.set('ENTRIES', 'Number', str(num_tilesets))
    for i, k in enumerate(dictionary.keys()):
        result.set('ENTRIES', "Name%03d" % (i+1,), k.lower())

    for v in dictionary.values():
        if len(args.enter):
            v['OnEnter'] = args.enter
        if len(args.exit):
            v['OnExit'] = args.exit
        if len(args.user):
            v['OnUserDefined'] = args.user
        if len(args.heartbeat):
            v['OnHeartbeat'] = args.heartbeat

    for k, v in dictionary.items():
        #result.add_section(k.upper())
        result.add_section(k)
        for k2, v2 in v.items():
            result.set(k, k2, v2)

    with open(args.output, 'w') as configfile:
        result.write(configfile, space_around_delimiters=False)
