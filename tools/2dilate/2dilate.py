#!/usr/bin/env python

from pynwn.file.twoda import TwoDA
from pynwn.file.twodx import TwoDX
from pynwn.TwoDXMerger import TwoDXMerger
from pynwn.resource import ContentObject

import os
import re
import fnmatch
import argparse
import zipfile
import sys
import io

parser = argparse.ArgumentParser()
parser.add_argument('-v', '--version', action='version', version='0.1')
parser.add_argument('-o', '--output', help='Output directory.', default='merged')
parser.add_argument('-x', '--twodx', help='2dx directory.', default='2dx')
parser.add_argument('--non-default', help='Ignore non-default 2da row entries.', action='store_true')
parser.add_argument('files', help='2da file(s).', nargs='+')

args = parser.parse_args()

def safe_mkdir(path):
    if not os.path.exists(path):
        os.makedirs(path)

def get_2dxs(base):
    matches = []
    for root, dirnames, filenames in os.walk(args.twodx):
        for filename in fnmatch.filter(filenames, base+'+*.2dx'):
            base = os.path.basename(filename)
            matches.append(os.path.join(root, filename))

    return matches

if __name__ == "__main__":
    safe_mkdir(args.output)
    tdasource = None
    if args.non_default:
        tdasource = zipfile.ZipFile('2dasource.zip')

    for f in args.files:
        basef = os.path.basename(f)
        base = os.path.splitext(basef)[0]
        twodxs = get_2dxs(base)
        twoda = TwoDA(f)

        default = None
        if args.non_default:
            deffile = tdasource.open(basef)
            defcont = deffile.read()
            co = ContentObject(base, 2017, io.StringIO(defcont.decode(sys.stdout.encoding)))
            default = TwoDA(co)

        merged = False
        for twodx in twodxs:
            x = TwoDX(twodx)
            if x.description:
                print("Applying: %s" % x.description)
            else:
                print("Merging %s." % twodx)

            merger = TwoDXMerger(twoda, x, default)
            merger.merge()
            merged = True

        if merged:
            with open(os.path.join(args.output, basef), 'w') as f2:
                f2.write(str(twoda))
