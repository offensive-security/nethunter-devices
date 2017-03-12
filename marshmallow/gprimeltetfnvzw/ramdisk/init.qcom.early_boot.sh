#!/system/bin/sh
# Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

export PATH=/system/bin

# Set platform variables
if [ -f /sys/devices/soc0/hw_platform ]; then
    soc_hwplatform=`cat /sys/devices/soc0/hw_platform` 2> /dev/null
else
    soc_hwplatform=`cat /sys/devices/system/soc/soc0/hw_platform` 2> /dev/null
fi
if [ -f /sys/devices/soc0/soc_id ]; then
    soc_hwid=`cat /sys/devices/soc0/soc_id` 2> /dev/null
else
    soc_hwid=`cat /sys/devices/system/soc/soc0/id` 2> /dev/null
fi
if [ -f /sys/devices/soc0/platform_version ]; then
    soc_hwver=`cat /sys/devices/soc0/platform_version` 2> /dev/null
else
    soc_hwver=`cat /sys/devices/system/soc/soc0/platform_version` 2> /dev/null
fi
if [ -f /sys/class/graphics/fb0/virtual_size ]; then
    virtual_size=$(echo `cat /sys/class/graphics/fb0/virtual_size` | cut -d',' -f1) 2>/dev/null
fi

platform=`getprop ro.board.platform`
log -t BOOT -p i "MSM target '$platform', SoC '$soc_hwplatform', HwID '$soc_hwid', SoC ver '$soc_hwver', virtual size '$virtual_size'"

case "$platform" in
    "msm7630_surf" | "msm7630_1x" | "msm7630_fusion")
        case "$soc_hwplatform" in
            "FFA" | "SVLTE_FFA")
                # linking to surf_keypad_qwerty.kcm.bin instead of surf_keypad_numeric.kcm.bin so that
                # the UI keyboard works fine.
                ln -s  /system/usr/keychars/surf_keypad_qwerty.kcm.bin /system/usr/keychars/surf_keypad.kcm.bin
                ;;
            "Fluid")
                setprop ro.sf.lcd_density 240
                setprop qcom.bt.dev_power_class 2
                ;;
            *)
                ln -s  /system/usr/keychars/surf_keypad_qwerty.kcm.bin /system/usr/keychars/surf_keypad.kcm.bin
                ;;
        esac
        ;;

    "msm8660")
        case "$soc_hwplatform" in
            "Fluid")
                setprop ro.sf.lcd_density 240
                ;;
            "Dragon")
                setprop ro.sound.alsa "WM8903"
                ;;
        esac
        ;;

    "msm8960")
        # lcd density is write-once. Hence the separate switch case
        case "$soc_hwplatform" in
            "Liquid")
                if [ "$soc_hwver" == "196608" ]; then # version 0x30000 is 3D sku
                    setprop ro.sf.hwrotation 90
                fi

                setprop ro.sf.lcd_density 160
                ;;
            "MTP")
                setprop ro.sf.lcd_density 240
                ;;
            *)
                case "$soc_hwid" in
                    "109")
                        setprop ro.sf.lcd_density 160
                        ;;
                    *)
                        setprop ro.sf.lcd_density 240
                        ;;
                esac
            ;;
        esac

        #Set up composition type based on the target
        case "$soc_hwid" in
            87)
                #8960
                setprop debug.composition.type dyn
                ;;
            153|154|155|156|157|138)
                #8064 V2 PRIME | 8930AB | 8630AB | 8230AB | 8030AB | 8960AB
                setprop debug.composition.type c2d
                ;;
            *)
        esac
        ;;

    "msm8974")
        case "$soc_hwplatform" in
            "Liquid")
                setprop ro.sf.lcd_density 160
                # Liquid do not have hardware navigation keys, so enable
                # Android sw navigation bar
                setprop ro.hw.nav_keys 0
                ;;
            "Dragon")
                setprop ro.sf.lcd_density 240
                ;;
            *)
                setprop ro.sf.lcd_density 320
                ;;
        esac
        ;;

    "msm8226")
        case "$soc_hwplatform" in
            *)
                setprop ro.sf.lcd_density 320
                ;;
        esac
        ;;

    "msm8610" | "apq8084" | "mpq8092")
        case "$soc_hwplatform" in
            *)
                setprop ro.sf.lcd_density 240
                ;;
        esac
        ;;
    "apq8084")
        case "$soc_hwplatform" in
            "Liquid")
                setprop ro.sf.lcd_density 320
                # Liquid do not have hardware navigation keys, so enable
                # Android sw navigation bar
                setprop ro.hw.nav_keys 0
                ;;
            "SBC")
                setprop ro.sf.lcd_density 200
                # SBC do not have hardware navigation keys, so enable
                # Android sw navigation bar
                setprop qemu.hw.mainkeys 0
                ;;
            *)
                setprop ro.sf.lcd_density 480
                ;;
        esac
        ;;
    "msm8916" | "msm8909")
        if test -n "$virtual_size"
        then
            if [ $virtual_size -ge "1080" ]
            then
                if [ $soc_hwplatform == "SBC" ]
                then
                    setprop ro.sf.lcd_density 240
                    setprop qemu.hw.mainkeys 0
                else
                    setprop ro.sf.lcd_density 480
                fi
            elif [ $virtual_size -ge "720" ]
            then
                setprop ro.sf.lcd_density 320
            elif [ $virtual_size -ge "480" ]
            then
                setprop ro.sf.lcd_density 240
            else
                setprop ro.sf.lcd_density 320
            fi
        fi

        # Set ro.opengles.version based on chip id.
        # MSM8939 variants supports OpenGLES 3.1
        # 196608 is decimal for 0x30000 to report version 3.0
        # 196609 is decimal for 0x30001 to report version 3.1
        case "$soc_hwid" in
            233|239|240|241|242|243|263|268|269|270|271)
                setprop ro.opengles.version 196609
                if [ $soc_hwid -ge "239" ] && [ $soc_hwid -le "243" ]
                then
                    setprop media.msm8939hw 1
                fi
                if [ $soc_hwid -ge "268" ] && [ $soc_hwid -le "271" ]
                then
                    setprop media.msm8929hw 1
                fi
                ;;
            *)
                setprop ro.opengles.version 196608
                ;;
        esac

	# auto firmware upgrade for ITE tecg touch screen
        case $platform in
            "msm8909" | "msm8909w")
                case $soc_hwplatform in
                    "MTP")
                        echo 1 > /sys/bus/i2c/devices/5-0046/cfg_update
                        echo 1 > /sys/bus/i2c/devices/5-0046/fw_update
                        ;;
                esac
                ;;
        esac
	;;
esac

# Setup display nodes & permissions
# HDMI can be fb1 or fb2
# Loop through the sysfs nodes and determine
# the HDMI(dtv panel)

function set_perms() {
    #Usage set_perms <filename> <ownership> <permission>
    chown -h $2 $1
    chmod $3 $1
}

for fb_cnt in 0 1 2
do
file=/sys/class/graphics/fb$fb_cnt
dev_file=/dev/graphics/fb$fb_cnt
  if [ -d "$file" ]
  then
    value=`cat $file/msm_fb_type`
    case "$value" in
            "dtv panel")
        set_perms $file/hpd system.graphics 0664
        set_perms $file/res_info system.graphics 0664
        set_perms $file/vendor_name system.graphics 0664
        set_perms $file/product_description system.graphics 0664
        set_perms $file/video_mode system.graphics 0664
        set_perms $file/format_3d system.graphics 0664
        set_perms $file/s3d_mode system.graphics 0664
        set_perms $file/cec/enable system.graphics 0664
        set_perms $file/cec/logical_addr system.graphics 0664
        set_perms $file/cec/rd_msg system.graphics 0664
        set_perms $file/pa system.graphics 0664
        set_perms $file/cec/wr_msg system.graphics 0600
        set_perms $file/hdcp/tp system.graphics 0664
        ln -s $dev_file /dev/graphics/hdmi
    esac
    if [ $fb_cnt -eq 0 ]
    then
        set_perms $file/idle_time system.graphics 0664
        set_perms $file/dynamic_fps system.graphics 0664
        set_perms $file/dyn_pu system.graphics 0664
        set_perms $file/modes system.graphics 0664
        set_perms $file/mode system.graphics 0664
        set_perms $file/mdp/bw_mode_bitmap system.graphics 0664
    fi
  fi
done

boot_reason=`cat /proc/sys/kernel/boot_reason`
reboot_reason=`getprop ro.boot.alarmboot`
power_off_alarm_file=`cat /persist/alarm/powerOffAlarmSet`
if [ "$boot_reason" = "3" ] || [ "$reboot_reason" = "true" ]; then
    if [ "$power_off_alarm_file" = "1" ]
    then
        setprop ro.alarm_boot true
        setprop debug.sf.nobootanimation 1
    fi
else
    setprop ro.alarm_boot false
fi
