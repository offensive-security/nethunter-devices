#!/bin/bash
# script for configuring NetHunter kernels by jcadduono

################### BEFORE STARTING ################
#
# download a working toolchain and extract it somewhere and configure this
# file to point to the toolchain's root directory.
# this file should be placed in your kernel source folder with
# the CONFIG section edited to work for your device.
#
# once you've set up the config section how you like it, you can simply run
# ./menuconfig.sh [DEVICE] [TARGET]
#
# make a copy of your device's original defconfig file.
# the new defconfig file should follow the format:
# arch/arm64/configs/nethunter_yourdevice_defconfig
#
###################### CONFIG ######################

# default device name (change this!)
DEFAULT_DEVICE=yourdevice

# default target name
DEFAULT_TARGET=nethunter

# directory containing cross-compile arm64 toolchain (change this!)
TOOLCHAIN=/opt/toolchain/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu

############## SCARY NO-TOUCHY STUFF ###############

# root directory of kernel source git repo (default is this script's location)
RDIR=$(pwd)

ABORT() {
	[ "$1" ] && echo "Error: $*"
	exit 1
}

export ARCH=arm64
export CROSS_COMPILE=$TOOLCHAIN/bin/aarch64-linux-gnu-

[ -x "${CROSS_COMPILE}gcc" ] ||
ABORT "Unable to find gcc cross-compiler at location: ${CROSS_COMPILE}gcc"

while [ $# != 0 ]; do
	if [ ! "$DEVICE" ]; then
		DEVICE=$1
	elif [ ! "$TARGET" ]; then
		TARGET=$1
	else
		echo "Too many arguments!"
		echo "Usage: ./menuconfig.sh [device] [target defconfig]"
		ABORT
	fi
	shift
done

[ "$DEVICE" ] || DEVICE=$DEFAULT_DEVICE
[ "$TARGET" ] || TARGET=$DEFAULT_TARGET
DEFCONFIG=${TARGET}_${DEVICE}_defconfig
DEFCONFIG_FILE=$RDIR/arch/$ARCH/configs/$DEFCONFIG

[ -f "$DEFCONFIG_FILE" ] ||
ABORT "Device config $DEFCONFIG not found in $ARCH configs!"

cd "$RDIR" || ABORT "Failed to enter $RDIR!"

echo "Cleaning build..."
rm -rf build
mkdir build
make -s -i -C "$RDIR" O=build "$DEFCONFIG" menuconfig
echo "Showing differences between old config and new config"
echo "-----------------------------------------------------"
if command -v colordiff >/dev/null 2>&1; then
	diff -Bwu --label "old config" "$DEFCONFIG_FILE" --label "new config" build/.config | colordiff
else
	diff -Bwu --label "old config" "$DEFCONFIG_FILE" --label "new config" build/.config
	echo "-----------------------------------------------------"
	echo "Consider installing the colordiff package to make diffs easier to read"
fi
echo "-----------------------------------------------------"
echo -n "Are you satisfied with these changes? y/N: "
read -r option
case $option in
y|Y)
	cp build/.config "$DEFCONFIG_FILE"
	echo "Copied new config to $DEFCONFIG_FILE"
	;;
*)
	echo "That's unfortunate"
	;;
esac
echo "Cleaning build..."
rm -rf build
echo "Done."
