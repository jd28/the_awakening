#!/bin/bash

MOVE="ncs/$1*.ncs"
NCS="c:/Users/josh/software/NWN/modules/temp0/$1*.ncs"
MOD="c:/Users/josh/software/NWN/modules/temp0"

rm $NCS
make
cp $MOVE $MOD
