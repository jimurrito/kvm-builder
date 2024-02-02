#!/bin/bash

: '

KVM Builder

'
#
#
STARTUP=$SECONDS
ARGC=0
ARGS=("$@")
ROOTDIR=$(dirname $0)
LIBDIR=$ROOTDIR/lib
#
# Import external scripts & config
source $LIBDIR/defaults.bash
source $LIBDIR/handlers.bash
source $LIBDIR/menus.bash
source $LIBDIR/build.bash
#
#
# Parse Input Vars
for ARG in "${ARGS[@]}"; do
    case $ARG in
    # Name (Rq)
    "-n" | "--name")
        NAME=${ARGS[$ARGC+1]} ;;
    # OS type Linux (Def Linux)
    "-L" | "--linux")
        OSTYPE="linux" ;;
    # OS type Windows
    "-W" | "--windows")
        OSTYPE="windows" ;;
    # VM disk dir
    "-d" | "--diskpath")
        DISKPATH=${ARGS[$ARGC+1]} ;; 
    # IOSPath (Opt)
    "-o" | "--iospath")
        IOSPATH=${ARGS[$ARGC+1]} ;;
    # Virt Driver ISO  - WIN ONLY
    "-O" | "--virtpath")
        VIRT_ISOPATH=${ARGS[$ARGC+1]} ;;
    # Network (Opt)
    "-n" | "--network")
        NETWORK=${ARGS[$ARGC+1]} ;;
    # Pre-made size
    "-z" | "--size")
        SIZE=${ARGS[$ARGC+1]} ;;
    #
    # <CUSTOM VM SIZE>*
    #
    # Enable custom vm size (Rq*)
    "-c" | "--custom")
        CUSTOM=true ;;
    # Amount of CPU cores (Opt)
    "--cores")
        CORES=${ARGS[$ARGC+1]} ;;
    # Amount of ram (Opt)
    "--ram")
        RAM=${ARGS[$ARGC+1]} ;;
    #
    #
    # Amount of disk storage (Opt) (Def: 32gb Linux | 64gb Windows)
    "-s" | "--storage")
        STORE=${ARGS[$ARGC+1]} ;;
    #
    #
    # Help menu
    "-h" | "--help")
        MENU=${ARGS[$ARGC+1]}
        if [[ ${MENU,,} == "size" ]]; then
            printf '%s' "$SIZEMENU"
        else
            printf '%s' "$HELPMENU"
        fi
        exit
    ;;
    esac
    # Iterate
    ARGC=$(($ARGC + 1))
done
#
# <Set Defaults>
# Fill in default values from ./lib/defaults.bash and hard coded
VM_OSTYPE=$(setdef $VM_OSTYPE "linux")
NETWORK=$(setdef $NETWORK $KVMBLDR_DEF_VMNETW)
SIZE=$(setdef $SIZE $KVMBLDR_DEF_VMSIZE)
DISKPATH=$(setdef $DISKPATH $KVMBLDR_DEF_DISKDIR)
if [[ "$VM_OSTYPE" == "linux" ]]; then
    # If linux
    ISOPATH=$(setdef $IOSPATH $KVMBLDR_DEF_LNXISODIR)
    STORE=$(setdef $STORE $KVMBLDR_DEF_LNXDISKSZ)
else
    # if windows
    ISOPATH=$(setdef $IOSPATH $KVMBLDR_DEF_WINISODIR)
    VIRT_ISOPATH=$(setdef $VIRT_ISOPATH $KVMBLDR_DEF_WINVIRTISODIR)
    STORE=$(setdef $STORE $KVMBLDR_DEF_WINDISKSZ)
fi
#
# <Input Validation>
ec "$NAME" "[0x1] No VM Name provided. Please use -n/--name to provide a name. Use -h/--help to get to the help menu"
ec "$NETWORK" "[0x1] No VM Network provided. Please use -n/--network to provide a device. Option can be hard coded via /lib/defaults.bash. Use -h/--help to get to the help menu"
ec "$ISOPATH" "[0x1] No VM ISO provided. Please use -o/--isopath to provide and path. Option can be hard coded via /lib/defaults.bash. Use -h/--help to get to the help menu"

# Custom Confirm check
if [[ $CUSTOM ]]; then
    # 
    ec "$CORES" "[0x1][Custom-Builder] Number of CPU cores requied. Please use --cores to provide an amount. Use -h/--help to get to the help menu"
    ec "$RAM" "[0x1][Custom-Builder] Amount of RAM required. Please use --ram to provide an amount. Use -h/--help to get to the help menu"
    ec "$STORE" "[0x1][Custom-Builder] Amount of Disk Storage required. Please use --storage to provide an amount. Use -h/--help to get to the help menu"
    #
else
    #
    ec "$SIZE" "[0x1] No VM Size provided. Please use -z/--size to provide a size. To see size options use: '-h size'. Use -h/--help to get to the help menu"
fi
#
# Assign size - pre-defined sizes
if [[ ! $CUSTOM && -n $SIZE ]]; then
    # Double parenteses to ensure output is a list
    SIZEn=($(size_find "$SIZE"))
    CORES=${SIZEn[0]}
    RAM=${SIZEn[1]}
fi
# Final size validation
if [[ $CORES == false ]]; then
    echo "[0x1] Invalid VM Size provided on -s/--size. Options are 'win' or 'lin'. Use -h/--help to get to the help menu"
    exit 1
fi
#
# Validate network device exists
if [[ ! $(networkctl --no-pager | grep "$NETWORK") ]]; then
    echo "[0x1] Invalid network device provided: $NETWORK. Please check and ensure there is no typo on the device name. Use -h/--help to get to the help menu"
    exit 1
fi
#
#
printf "
-Pre-Build Summary-
    Name     %s
    Type     %s
    ISO      %s
    Size     %s
    Cores    %s
    Ram      %s
    Store    %s
    Netw     %s

" "$NAME" "$VM_OSTYPE" "$ISOPATH" "${SIZE^^}" "$CORES" "$RAM" "$STORE" "$NETWORK"
echo ""
#
printf "Last chance to cancel. Starting build in 5s"
for _ in {1..5}; do
    printf " ."
    sleep 1
done
echo ""
#
# -MAIN BUILD-
#
# Make VMs directory
fc "$(mkdir -p "$DISKPATH"/"$NAME" 2>&1)" "[0x1] Failed to Create the Virual Machine's directory: '$KVMBLDR_DEF_DISKDIR/$NAME'"
#
# Convert Int to MB
RAM=$(($RAM * 1024))
#
#
# Linux Build
if [[ "$VM_OSTYPE" == "linux" ]]; then
    #
    build_new_lnx "$NAME" \
     "$CORES" $RAM "$STORE" \
     "$NETWORK" "$DISKPATH" \
     "$ISOPATH"
# Windows build
else
    #
    build_new_win "$NAME" \
     "$CORES" $RAM "$STORE" \
     "$NETWORK" "$DISKPATH" \
     "$ISOPATH" "$VIRT_ISOPATH"
    #

fi
#
echo "Finished. Completed in ($(( $SECONDS - $STARTUP )))s"




