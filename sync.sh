SSH='ssh -l'

rsync -r -a -v  -e "$SSH $1" --checksum --delete  ./scripts/lua $2:/opt/nwn
rsync -r -a -v  -e "$SSH $1" --checksum --delete ./resman/ncs $2:/opt/nwn/resman
rsync -r -a -v  -e "$SSH $1" --checksum ./tlk $2:/opt/nwn/
