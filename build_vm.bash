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
    # Type (Rq)
    "-t" | "--type")
        OSTYPE=${ARGS[$ARGC+1]}
        OSTYPE=${OSTYPE,,} ;;
    # OSPath (Opt)
    "-o" | "--ospath")
        OSPATH=${ARGS[$ARGC+1]} ;;
    # Network (Opt)
    "-N" | "--network")
        NETWORK=${ARGS[$ARGC+1]} ;;
    # Pre-made size (Rq*)
    "-z" | "--size")
        SIZE=${ARGS[$ARGC+1]} ;;
    # Import from generalized/backup
    "-i" | "--import")
        IMPORT=${ARGS[$ARGC+1]} ;; 
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
    # Amount of disk storage (Opt) (Def: 30gb Linux | 60gb Windows)
    "-s" | "--storage")
        STORE=${ARGS[$ARGC+1]} ;;
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
#
# <Input Validation>
ec "$NAME" "[0x1] No VM Name provided. Please use -n/--name to provide a name. Use -h/--help to get to the help menu"
ec "$OSTYPE" "[0x1] No VM Type provided. Please use -t/--type to provide a type. Options: [win,lin]. Use -h/--help to get to the help menu"
ec "$KVMBLDR_DEF_VMNETW" "[0x1] No VM Network provided. Please use -N/--network to provide a device. Option can be hard coded in the script. Use -h/--help to get to the help menu"
# Custom Confirm check
if [[ $CUSTOM ]]; then
    # 
    ec "$CORES" "[0x1][Custom-Builder] Number of CPU cores requied. Please use --cores to provide an amount. Use -h/--help to get to the help menu"
    ec "$RAM" "[0x1][Custom-Builder] Amount of RAM required. Please use --ram to provide an amount. Use -h/--help to get to the help menu"
    ec "$STORE" "[0x1][Custom-Builder] Amount of Disk Storage required. Please use --storage to provide an amount. Use -h/--help to get to the help menu"
    #
else
    #
    ec "$SIZE" "[0x1] No VM Size provided. Please use -s/--size to provide a size. To see size options use: '-h size'. Use -h/--help to get to the help menu"
fi
#
# OsPath Check
if [[ -z $OSPATH ]]; then
    case $OSTYPE in
        "win")
        OSPATH=$KVMBLDR_DEF_WINISODIR ;;
        "lin")
        OSPATH=$KVMBLDR_DEF_LNXISODIR ;;
        *)
        ec "" "[0x1] Invalid Os Path provided on -o/--ospath. Use -h/--help to get to the help menu"
    esac

fi
ec "$OSPATH" "[0x1] Default paths within the script are missing. Please adjust this, or use -o/--ospath to provide a path to an OS. Use -h/--help to get to the help menu"
#
# Assign default disk size
case $OSTYPE in
    "win")
    STORE=$KVMBLDR_DEF_WINDISKSZ ;;
    "lin")
    STORE=$KVMBLDR_DEF_LNXDISKSZ ;;
    *)
    ec "" "[0x1] Invalid Os Type provided on -t/--type. Options are 'win' or 'lin'. Use -h/--help to get to the help menu"
esac
#
# Assign size
if [[ ! $CUSTOM && -n $SIZE ]]; then
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
if [[ ! $(networkctl --no-pager | grep "$KVMBLDR_DEF_VMNETW") ]]; then
    echo "[0x1] Invalid network device provided: $KVMBLDR_DEF_VMNETW. Please check and ensure there is no typo on the device name. Use -h/--help to get to the help menu"
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

" "$NAME" "$OSTYPE" "$OSPATH" "$SIZE" "$CORES" "$RAM" "$STORE" "$KVMBLDR_DEF_VMNETW"
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
fc "$(mkdir -p "$KVMBLDR_DEF_DISKDIR"/"$NAME" 2>&1)" "[0x1] Failed to Create the Virual Machine's directory: '$KVMBLDR_DEF_DISKDIR/$NAME'"
#
# Convert Int to MB
RAM=$(($RAM * 1024))
#
#
# <Build new> - Windows build
if [[ "$OSTYPE" == "win" && ! $IMPORT ]]; then
    #
    build_new_win "$NAME" \
     "$CORES" $RAM "$STORE" \
     "$KVMBLDR_DEF_VMNETW" "$VMBLDR_DEF_DISKDIR" \
     "$KVMBLDR_DEF_WINISODIR" "$KVMBLDR_DEF_WINVIRTISODIR"
    #
# <Build new> - Linux Build
elif [[ "$OSTYPE" == "lin" && ! $IMPORT ]]; then
    #
    build_new_lnx "$NAME" \
     "$CORES" $RAM "$STORE" \
     "$KVMBLDR_DEF_VMNETW" "$VMBLDR_DEF_DISKDIR" \
     "$KVMBLDR_DEF_LNXISODIR"

fi
#
echo "Finished. Completed in ($(( $SECONDS - $STARTUP )))s"




