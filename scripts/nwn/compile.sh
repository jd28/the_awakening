#!/bin/bash

NCS="c:/Users/josh/software/NWN/modules/temp0/$1*.ncs"
MOVE="ncs/$1*.ncs"
MASK="$1*.nss"
MOD="c:/Users/josh/software/NWN/modules/temp0"

rm $NCS
make
cp $MOVE $MOD
