#!/bin/bash

#
# Help Menu
HELPMENU='KVM Builder - Help Menu
    -n --name     Name of the VM - Req.
    -L --linux    VM will be Linux based (Default)
    -W --windows  VM will be Windows based.
    -d --diskpath Path to where the VMs OS disk will go. - Req.
    -o --iospath  Path to ISO used by the VM
    -O --virtpath Path to the ISO containing QEMU drivers. (Windows Only)
    -n --network  Network for the VM
    -z --size     Pre-defined Size of the VM (Default Size: AA - 1 Core, 2GB Ram)
                      For the size menu, use "-h size"
    -h --help     This menu

-Custom Sized VMs-
    -c --custom   Enables the use of custom VM sizes
       --cores    Amount of cores (Max: 8)
       --ram      Amount of Ram in GB (Max: 10)
    -s --storage  Amount of disk storage in GB (Max: 100)

'

#
# Size menu
SIZEMENU='KVM Builder - Pre-made sizes menu
-CPU & RAM-
    A - 1c/1gb
    AA - 1c/2gb
    B - 2c/2gb
    BB - 2c/4gb
    C - 4c/2gb
    CC - 4c/4gb
    D - 4c/6gb
    DD - 4c/8gb
    E - 6c/4gb
    EE - 6c/8gb

-Storage-
    [Defaults]
    Linux - 32GB
    Windows - 64GB

'

