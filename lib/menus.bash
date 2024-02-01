#!/bin/bash

#
# Help Menu
HELPMENU='KVM Builder - Help Menu
    -n --name     Name of the VM - Req.
    -t --type     Type of OS [win,lin] - Req.
    -o --ospath   Path to ISO used by the VM
    -N --network  Network for the VM
    -z --size     Pre-defined Size of the VM - Req. if not using Custom.
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

# Size Selector
size_find() {
    #
    case ${1,,} in
        # A
        "a")
            OUT=(1 1)     
        ;;
        # AA
        "aa")
            OUT=(1 2)   
        ;;
        # B
        "b")
            OUT=(2 2)  
        ;;
        # BB
        "bb")
            OUT=(2 4)   
        ;;
        # C
        "c")
            OUT=(4 2)
        ;;
        # CC
        "cc")
            OUT=(4 4)
        ;;
        # D
        "d")
            OUT=(4 6) 
        ;;
        # DD
        "dd")
            OUT=(4 8)
        ;;
        # E
        "e")
            OUT=(6 4)
        ;;
        # EE
        "ee")
            OUT=(6 8) 
        ;;
        # Catch-all
        *)
            OUT=false
    esac
    #
    echo "${OUT[@]}"
}