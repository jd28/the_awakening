#!/usr/bin/env python

import re
import os

include_dirs = ['nss', 'include', 'bioware']

import sys
assert(len(sys.argv) > 1)

visted = {}

def get_includes(source):
    incs = []
    if source in visted: return []
    visted[source] = True
    enc = { 'encoding': "latin1" } if sys.hexversion >= 0x03000000 else {}
    with open(source, **enc) as f:
        for line in f.readlines():
            m = re.match(r'^#include[ 	]*"(.*)"', line)
            if m:
                shit = m.group(1)
                incs.append(shit.lower())
                for d in include_dirs:
                    next_source = os.path.join(d, shit) + '.nss'
                    if os.path.isfile(next_source):
                        incs += get_includes(next_source)
                        break
    return incs

res = set(get_includes(sys.argv[1]))


source = os.path.basename(sys.argv[1])
source = os.path.splitext(source)[0]

nss = ' '.join([r + '.nss' for r in res])
if len(res):
    print(source + ".ncs: " + nss)
print("ncs/" + source + ".d: " + source)
