#!/system/bin/sh

# Check the location of BusyBox

if [ ! -f /su/xbin/busybox ]; then
	BB=/system/xbin/busybox;
else
	BB=/su/xbin/busybox;
fi;

# Mount rootfs and system as RW

mount -o rw,remount rootfs;

# Fix permissions

chmod 0666 /sys/devices/14ac0000.mali/dvfs_governor
chmod 0666 /sys/module/workqueue/parameters/power_efficient

# Synapse

chmod -R 755 /res/*;

# Create uci link if not present

if [ ! -e /system/bin/uci ]; then
     ln -s ../../res/synapse/uci /system/bin/uci
fi

