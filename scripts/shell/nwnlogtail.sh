#!/bin/bash

# The following script if from Acaos' NWNIAB VirtualBox VM.

trap ret=1 INT TERM
cd "/opt/nwn/logs.0/"

while true; do
    tail -f nwserverLog1.txt
    sleep 1
    echo -n "-- log restarted at " >> nwserverLog1.txt
    date -u >> nwserverLog1.txt
    echo "" >> nwserverLog1.txt
done
