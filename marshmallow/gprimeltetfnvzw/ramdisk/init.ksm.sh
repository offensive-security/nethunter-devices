#!/system/bin/sh

ksm_enabled=`getprop ro.config.ksm`
timeout=45

LOG_TAG="config_ksm"
LOG_NAME="${0}:"

loge ()
{
  /system/bin/log -t $LOG_TAG -p e "$LOG_NAME $@"
}

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

logi "In KSM Script"
logi "running : $ksm_enabled"
logi "timeout : $timeout"

while ! [ `sleep $timeout` ]; do
	if [ "$ksm_enabled" != true ]; then
		logi "Writing to /sys/kernel/mm/ksm/run ... "
		echo "0" > /sys/kernel/mm/ksm/run
	else
		loge "KSM is enabled, shutting down ... "
		exit 0
	fi
done
