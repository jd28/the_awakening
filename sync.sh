#!/bin/sh

SSH='ssh -l'

rsync -r -a -v  -e "$SSH $1" --checksum ./scripts/lua $2:/opt/nwn
rsync -r -a -v  -e "$SSH $1" --exclude="global_events.ncs" --include="*.ncs" scripts/nwn/ncs/ $2:/opt/nwn/physfs/
rsync -r -a -v  -e "$SSH $1" --checksum ./tlk $2:/opt/nwn/
