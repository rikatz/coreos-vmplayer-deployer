# CoreOS Deployer

Script to deploy a CoreOS instance into VMWare Player, using a Container Linux Configuration to bootstrap the machine

## Pre reqs

* CoreOS Configuration Transpiler -> [https://github.com/coreos/container-linux-config-transpiler/releases]

* VMware Player Free

* CoreOS Container Linux OVA Image -> [https://stable.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ova]

* A directory to contain the virtual machines.

## Usage

* Verify what's the NAT IP Network created by your VMWare Player Installer: `cat /etc/vmware/networking  |grep VNET_8`

* Copy the template.yaml file to some other name/config you wan't to use and change the values to reflect your needs and environment

* Execute the script

```
./scripts/deploy.sh machine1.yaml coreos_production_vmware_ova.ova vms/ machine1
```

* Poweron the VM

```
vmplayer vms/machine1/machine1.vmx
```
