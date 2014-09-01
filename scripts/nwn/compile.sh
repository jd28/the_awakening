#!/bin/bash

NCS="c:/Users/josh/software/NWN/modules/temp0/$1*.ncs"
MOVE="ncs/$1*.ncs"
MASK="nss/$1*.nss"
MOD="c:/Users/josh/software/NWN/modules/temp0"

rm $NCS
NWNScriptCompiler.exe -b ncs -i "nss;include;bioware" -1cego "$MASK"
mv $MOVE $MOD
