areaglob is simple little utility script to take a bunch of ini files in the
areag.ini format and smush them in to one.  There are command line
options for setting the script settings for all the final areag.ini
tileset entries.  If anyone would like an exe version I would be happy
to make one.

See the areag folder in the 7z for how you'd use it.  Most tileset
haks seem to come with a merged one, so there is a lot of needless
duplication in those files.

#### Dependencies:
* [Python 3](https://www.python.org/)

#### Command Line Arguments:
```
usage: areaglob.py [-h] [-v] [-o OUTPUT] [-a AREAG] [-e ENTER] [-x EXIT]
                   [-b HEARTBEAT] [-u USER]
                   file

positional arguments:
  file                  Base areag.ini file.

optional arguments:
  -h, --help            show this help message and exit
  -v, --version         show program's version number and exit
  -o OUTPUT, --output OUTPUT
                        Output file.
  -a AREAG, --areag AREAG
                        areag.ini directory.
  -e ENTER, --enter ENTER
                        OnEnter Script.
  -x EXIT, --exit EXIT  OnExit Script.
  -b HEARTBEAT, --heartbeat HEARTBEAT
                        OnHeartbeat Script.
  -u USER, --user USER  OnUserDefined Script.
```
