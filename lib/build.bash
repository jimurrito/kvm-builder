#!/bin/bash
# Scripts to build VMs

#
build_new_win() {
    NAME=$1
    CORES=$2
    RAM=$3
    STORE=$4
    NETWORK=$5
    DISK_DIR=$6
    WINISO_DIR=$7
    WINVIRTISO_DIR=$8
    #
    sudo virt-install \
        --name="$NAME" \
        --vcpus="$CORES" \
        --ram=$RAM \
        --disk path="$DISK_DIR"/"$NAME"/os_disk.raw,format=raw,size="$STORE" \
        --cdrom "$WINISO_DIR" \
        --disk path="$WINVIRTISO_DIR",device=cdrom \
        --graphics vnc,listen=0.0.0.0 \
        --network bridge="$NETWORK",model=virtio \
        --os-variant win10 \
        --accelerate \
        -v \
        --boot uefi \
        --autostart
}


#
build_new_lnx() {
    NAME=$1
    CORES=$2
    RAM=$3
    STORE=$4
    NETWORK=$5
    DISK_DIR=$6
    LNXISO_DIR=$7
    #
    sudo virt-install \
        --name="$NAME" \
        --vcpus="$CORES" \
        --ram=$RAM \
        --disk path="$DISK_DIR"/"$NAME"/os_disk.raw,format=raw,size="$STORE" \
        --cdrom "$LNXISO_DIR" \
        --graphics vnc,listen=0.0.0.0 \
        --network bridge="$NETWORK",model=virtio \
        --os-variant generic \
        --accelerate \
        -v \
        --boot uefi \
        --autostart
}
