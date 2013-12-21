#!/bin/bash

CP="nss/*.nss" 
MASK="nss/$1*.nss"
MOVE="nss/$1*.ncs"
NCS="ncs/$1*.ncs"
MOD="c:/Users/josh/software/NWN/modules/temp0"
RM_MOD_NSS="$MOD/*.nss"

echo "$MASK"
#echo $NCS
echo $MOD

#cp $CP $MOD
rm $NCS
rm $RM_MOD_NSS
cp $CP $MOD
NWNScriptCompiler -1ceglo -n "c:/Users/josh/software/NWN" -r $MOD "$MASK"
rm $RM_MOD_NSS
mv $MOVE ../../resman/ncs/
