#!/bin/sh
#
sudo bash ..build_kvm.bash \
    --name chessh_nix \
    --iospath /disks/raid/storage/iso/nixos-minimal-23.11.2596-x86_64-linux.iso \
    --size B \
    --network enp37s0.br16
