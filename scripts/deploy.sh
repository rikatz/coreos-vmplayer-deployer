#!/bin/bash
# Script de deploy/criação de uma VM com CoreOS

CONFIG=$1
OVFFILE=$2
VMDIR=$3
VMNAME=$4

if [ $# -ne 4 ]; then
    echo "Usage: $0 CONFIGFILE OVFFILE VMDIR VMNAME"
    exit 10
fi

if [ ! -f "$CONFIG" ]; then
    echo "Configuration not found"
    exit 10
fi

if [ ! -f "$OVFFILE" ]; then
    echo "OVF file not found"
    exit 10
fi

if [ ! -d "$VMDIR" ]; then
    echo "VMDIR not found"
    exit 10
fi

if [  -z "$VMNAME" ]; then
    echo "VMNAME not found"
    exit 10
fi

if [ -f $(which ct) ] && [ -x "$(which ct)" ]; then
    CT=$(which ct)
    echo "Using configuration Transpiller: $CT"
else
    echo "CoreOS Configuration Transpiller (ct binnary) not found."
fi

if [ -f $(which ovftool) ] && [ -x "$(which ovftool)" ]; then
    OVFTOOL=$(which ovftool)
    echo "Using OVFTool: $OVFTOOL"
else
    echo "VMWare OVFTool (ovftool) not found."
fi

TMPCONF=$(cat "$CONFIG" |ct --pretty |base64 -w0)
if [ $? -ne 0 ]; then  
    echo "Error generating configuration"
    exit 1
fi

$OVFTOOL --allowExtraConfig --X:enableHiddenProperties --X:injectOvfEnv --name=${VMNAME} --memorySize:'*'=3072 \
         --extraConfig:guestinfo.coreos.config.data.encoding=base64 \
         --extraConfig:guestinfo.coreos.config.data=${TMPCONF} \
         --net:"VM Network"="NAT" $OVFFILE $VMDIR

sed -i 's/memsize = .*/memsize = "3072"/g' $VMDIR/${VMNAME}/${VMNAME}.vmx

if [ $? -eq 0 ]; then
    echo "VMX file created. You might Power it on now"
else    
    echo "Failed to create the VMX file"
fi
