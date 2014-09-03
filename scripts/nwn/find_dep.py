#!/usr/bin/env python

import re
import os

include_dirs = ['nss', 'include', 'bioware']

import sys
assert(len(sys.argv) > 1)

visted = {}

def get_includes_3(source):
    incs = []
    if source in visted: return []
    visted[source] = True
    with open(source, encoding="cp1252") as f:
        for line in f.readlines():
            m = re.match(r'^#include[ 	]*"(.*)"', line)
            if m:
                shit = m.group(1)
                incs.append(shit.lower())
                for d in include_dirs:
                    next_source = os.path.join(d, shit) + '.nss'
                    if os.path.isfile(next_source):
                        incs += get_includes_3(next_source)
                        break
    return incs

def get_includes_2(source):
    incs = []
    if source in visted: return []
    visted[source] = True
    with open(source) as f:
        for line in f.readlines():
            m = re.match(r'^#include[ 	]*"(.*)"', line)
            if m:
                shit = m.group(1)
                incs.append(shit.lower())
                for d in include_dirs:
                    next_source = os.path.join(d, shit) + '.nss'
                    if os.path.isfile(next_source):
                        incs += get_includes_2(next_source)
                        break
    return incs

res = None
if sys.hexversion < 0x03000000:
    res = set(get_includes_2(sys.argv[1]))
else:
    res = set(get_includes_3(sys.argv[1]))


source = os.path.basename(sys.argv[1])
source = os.path.splitext(source)[0]

nss = ' '.join([r + '.nss' for r in res])
if len(res):
    print(source + ".ncs: " + nss)
print("ncs/" + source + ".d: " + source)# + '.nss') + " "+ nss)
