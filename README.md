# Kali NetHunter Devices

This repository contains all the precompiled kernels, kernel modules, and installation scripts
necessary for building an installer tailored for a supported device.

It should be cloned by ./bootstrap.sh in the nethunter-installer directory of the main Kali NetHunter repository.  
You can find that here: https://github.com/offensive-security/kali-nethunter/tree/master/nethunter-installer

## How to add a new/unsupported device

All devices are contained in devices.cfg.  If you want to add your own device you would add something like:

```sh
# Full device name for CyanogenMod (or some other ROM)
[codename]
author = "Your Name"
version = "1.0"
kernelstring = "NetHunter kernel or any name to call your kernel"
arch = armhf
devicenames = codename codename2_if_it_has_one
block = /dev/block/WHATEVER/boot
```
Some devices have more then one codename like the OnePlus One, or variants like the Nexus 7 2012/2013.  You should add multiple codenames to devicenames.  
Getting the block location isn't too difficult, you can look at other kernels to see where they are installing their boot.img or you can also look at CyanogenMod device repo in the BoardConfig.mk file.

A reliable way to get the codename for your device is to run a terminal emulator or boot into recovery and do:  
`getprop ro.product.device`  
I also recommend adding the model name to devicenames as well, which you can get from:  
`getprop ro.product.model`  

If porting for CyanogenMod rather than stock, it's recommended to append cm to the codename in [], ex. `[codenamecm]`

Once you have a device added to devices.cfg, you need to add a prebuilt kernel to the device's folder.  
It should be formatted as:  
`[androidversion]/[codename]/zImage` or `[androidversion]/[codename]/zImage-dtb` (for ARMv7 devices)  
`[androidversion]/[codename]/Image` or `[androidversion]/[codename]/Image.gz-dtb` (for ARMv8 devices)  

Some devices may require a separate dtb file. You can place a `dtb.img` file in the same location as the kernel image, and it will be automatically added to the installer.

So really all you need is a kernel image and sometimes a dtb.img to build for a new device.

Don't forget to add your newly supported device's kernel sources to the kernels.txt file!

Tue Jul 19 20:18:18 EST 2016
