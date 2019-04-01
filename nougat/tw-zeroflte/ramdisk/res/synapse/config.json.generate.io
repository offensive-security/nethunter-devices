#!/system/bin/sh

cat << CTAG
{
    name:I/O,
    elements:[
    { SPane:{
		title:"I/O schedulers",
		description:"Set the active I/O elevator algorithm. The scheduler decides how to handle I/O requests and how to handle them."
	}},
	{ SOptionList:{
		title:"Internal Storage Scheduler",
		default:`cat /sys/block/sda/queue/scheduler | busybox awk 'NR>1{print $1}' RS=[ FS=]`,
		action:"scheduler /sys/block/sda/queue/scheduler",
		values:[`while read values; do busybox printf "%s, \n" $values | busybox tr -d '[]'; done < /sys/block/sda/queue/scheduler`]
	}},
	{ SSeekBar:{
		title:"Internal_storage read-ahead",
		max:2048,
		min:128,
		unit:" kB",
		step:128,
		default:`cat /sys/block/sda/queue/read_ahead_kb`,
		action:"generic /sys/block/sda/queue/read_ahead_kb"
	}},
	{ SPane:{
		title:"I/O Tuning"
	}},
	{ SOptionList:{
		title:"Profile",
		description:" Select your profile for I/O.\n",
		default:`echo $(/res/synapse/actions/io io_tweaking)`,
		action:"io io_tweaking",
		values:[Default, Boost, Fast_Boost,],
	}},
	{ SPane:{
		title:"I/O Scheduler Tunables",
	}},
	{ STreeDescriptor:{
		path:"/sys/block/sda/queue/iosched",
		generic: {
			directory: {},
			element: {
				SGeneric: { title:"@BASENAME" }
			}
		},
		exclude: [ "weights" ]
	}},
		{ SPane:{
		title:"General I/O Tunables",
		description:"Set the internal storage general tunables"
	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"Enable Add Random",
		description:"Draw entropy from spinning (rotational) storage.\n",
		default:0,
		action:"ioset queue add_random",
		values:{
			0:"Disabled", 1:"Enabled"
		}
	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"Enable I/O Stats",
		description:"Maintain I/O statistics for this storage device. Disabling will break I/O monitoring apps but reduce CPU overhead.\n",
		default:0,
		action:"ioset queue iostats",
		values:{
			0:"Disabled", 1:"Enabled"
		}
	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"Enable Rotational",
		description:"Treat device as rotational storage.\n",
		default:0,
		action:"ioset queue rotational",
		values:{
			0:"Disabled", 1:"Enabled"
		}
	}},
    ]
}
CTAG
