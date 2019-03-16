# Kali NetHunter Devices

This repository contains all the precompiled kernels, kernel modules, and installation scripts
necessary for building an installer tailored for a supported device.

It should be cloned by `./bootstrap.sh` in the nethunter-installer directory of the main Kali NetHunter repository.  
You can find that here: https://github.com/offensive-security/kali-nethunter/tree/master/nethunter-installer

## How to add a new/unsupported device

All devices are contained in devices.cfg.  If you want to add your own device you would add something like:

```sh
# Full device name for LineageOS (or some other ROM)
[codename]
author = "Your Name"
version = "1.0"
kernelstring = "NetHunter kernel or any name to call your kernel"
arch = arm64
ramdisk = gzip
block = /dev/block/WHATEVER/by-name/boot
devicenames = codename codename2_if_it_has_one
```
Some devices have more than one codename like the OnePlus One, or variants like the Nexus 7 2012/2013.  You should add multiple codenames to devicenames.  
Getting the block location isn't too difficult, you can look at other kernels to see where they are installing their boot.img or you can also look at LineageOS device repo in the BoardConfig.mk file.

All fields are optional except the [codename] entry. It's recommended that you leave out any defaults from your device entry to keep it short.  
Here are the device entry option defaults:

```sh
author = "Unknown"
version = "1.0"
kernelstring = "NetHunter kernel"
arch = armhf
ramdisk = gzip
block = # empty, automatic searching for location
devicenames = # empty, will install on any device
```

A reliable way to get the codename for your device is to run a terminal emulator or boot into recovery and do:  
`getprop ro.product.device`  
I also recommend adding the model name to devicenames as well, which you can get from:  
`getprop ro.product.model`  
As a last resort, you can also include:  
`getprop ro.product.name`  
Keep in mind that each name is space delimited, and you can't quote them, so don't use values with spaces in them!  

If porting for LineageOS rather than stock, it's recommended to append -los to the codename in [], ex. `[codename-los]`

Once you have a device added to devices.cfg, you need to add a prebuilt kernel to the device's folder.  
It should be formatted as:  
`[androidversion]/[codename]/zImage` or `[androidversion]/[codename]/zImage-dtb` (for ARMv7 devices)  
`[androidversion]/[codename]/Image` or `[androidversion]/[codename]/Image.gz-dtb` (for ARMv8 devices)  

Some devices may require a separate dtb file. You can place a `dtb.img` file in the same location as the kernel image, and it will be automatically added to the installer.

If you choose to build kernel modules for your device instead of including them in the kernel image, they can be placed at the location:  
`[androidversion]/[codename]/modules/*.ko` or `[androidversion]/[codename]/modules/[kernelversion]/...`  
Please use the latter when possible by preparing your kernel modules for install (modprobe support) with the command:  
`make INSTALL_MOD_PATH="." INSTALL_MOD_STRIP=1 modules_install`  
Alternatively, use the build scripts mentioned below which do this already!  

So really all you need is a kernel image and sometimes a dtb.img to build for a new device.

Don't forget to add your newly supported device's kernel sources to the kernels.txt file!

## Building a kernel for your device

There are scripts in the `example_scripts` folder that you can copy to the root of your device's kernel sources.
They should be modified to match your device. It will make it easier to build your device's kernel outside of an Android source tree.

The binary output from the build will be self-contained in a `build` folder, with the kernel modules properly stripped and installed with their modprobe data in `build/lib/modules`.

Using these scripts in your source tree will make it easier for others to make modifications and update your device in the future. It will also increase the likelihood your device will be accepted into the nethunter-devices repository as an officially supported device!


Thu Feb 28 21:05:22 EST 2019
