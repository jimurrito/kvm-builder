# KVM Builder
Scripts to simply VM deployment via KVM/QEMU

## How to use (Simple)
```bash
sudo bash build_vm.bash -n Test_Linux

#
# Output
-Pre-Build Summary-
    Name     Test_Linux
    Type     linux
    ISO      /disks/storage/iso/debian-12.4.0-amd64-netinst.iso
    Size     AA
    Cores    1
    Ram      2
    Store    32
    Netw     enp37s0.br16


Last chance to cancel. Starting build in 5s . . .
```

This will create a VM, and bind it to a VNC port starting at `5900`. This is incremented up based on number of VMs deployed.

## How to use (Advanced)
```bash
sudo bash build_vm.bash \
    -n Test_Windows \
    -W \
    -d /disks/compute/KVM \
    -o /disks/storage/iso/windows10.iso \
    -O /disks/storage/iso/virtio.iso \
    -n enp37s0.br16 \
    -z BB

#
# Output
-Pre-Build Summary-
    Name     Test_Windows
    Type     windows
    ISO      /disks/storage/iso/windows10.iso
    Size     BB
    Cores    2
    Ram      4
    Store    64
    Netw     enp37s0.br16


Last chance to cancel. Starting build in 5s . . .
```

### Help and options

Help menu `-h`
``` bash
KVM Builder - Help Menu
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
```

Size matrix `-h size`
``` bash
KVM Builder - Pre-made sizes menu
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
```

## Setting defaults
New default values can be set under `./lib/defaults.bash`

``` bash
KVMBLDR_DEF_DISKDIR=/disks/compute/KVM
KVMBLDR_DEF_ISODIR=/disks/storage/iso
KVMBLDR_DEF_WINISO=windows10_21h2.iso
KVMBLDR_DEF_WINVIRTISO=virtio-win-0.1.229.iso
KVMBLDR_DEF_LNXISO=debian-12.4.0-amd64-netinst.iso
KVMBLDR_DEF_WINDISKSZ=64
KVMBLDR_DEF_LNXDISKSZ=32
KVMBLDR_DEF_VMNETW=enp37s0.br16
KVMBLDR_DEF_VMSIZE=aa
```

## Sample Pre-made builds
Under `./builds` you will find some sample builds.

`./builds/BUILD-jumpbox.sh`
``` bash
#!/bin/bash
sudo bash ../build_vm.bash \
    --name Jumper \
    -W \
    --size BB \
    --network enp37s0.br16
```

## Remove VMs
Included with this repo is a simple script to remove any created VMs.

``` bash
sudo bash remove_vm.sh Jumper 
```

This deletes both the XML config in KVM, and the vdisks used by the VM. Use with care.