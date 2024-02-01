#!/bin/sh
#
bash ..kvm_builder.bash \
    --name chessh_deb2 \
    --type lin \
    --ospath /disks/raid/storage/iso/debian-11.8.0-amd64-netinst.iso \
    --size B \
    --network enp37s0.br16
