#!/usr/bin/env python

from pynwn.file.twoda import TwoDA
from pynwn.file.twodx import TwoDX

import os
import re
import fnmatch

FNAME_RE = re.compile('(.*)\+.*.2dx')

twodas = {}

def get_2dxs():
    matches = []
    for root, dirnames, filenames in os.walk('2dx'):
        for filename in fnmatch.filter(filenames, '*.2dx'):
            matches.append(os.path.join(root, filename))
    return matches

for f in get_2dxs():
    base = os.path.basename(f)
    f2da = FNAME_RE.search(base).groups()[0] + ".2da"

    if not f2da in twodas:
        exists = None

        if os.path.isfile(os.path.join('server', f2da)):
            exists = os.path.join('server', f2da)
        elif os.path.isfile(os.path.join('bioware', f2da)):
            exists = os.path.join('bioware', f2da)

        if not exists:
            raise NameError('Unable to find base 2da: ' + f2da)

        twodas[f2da] = TwoDA(exists)

    x = TwoDX(f)
    twodas[f2da].merge_2dx(x)

for fname, twoda in twodas.items():
    with open(os.path.join('merged', fname), 'w') as f:
        f.write(str(twoda))
