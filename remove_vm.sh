#!/bin/bash
# Import default values
source "$(dirname $0)/lib/defaults.bash"
NAME=$1

sudo virsh destroy $NAME
sudo virsh undefine $NAME --nvram
sudo rm -rfv "$KVMBLDR_DEF_DISKDIR/$NAME"