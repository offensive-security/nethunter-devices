#!/system/bin/sh

cat << CTAG
{
    name:PROFILE,
    elements:[
		{ STitleBar:{
			title:"Profiles"
		}},
			{ SOptionList:{
				title:"Selected Profile",
				description:"Choose the settings you want and apply your choice in Synapse before using the action buttons below.",
				action:"restorebackup pickprofile",
				default:"None",
				values:[ "None",
					`for BAK in \`res/synapse/actions/restorebackup listprofile\`; do
						echo "\"$BAK\","
					done`
				],
				notify:[
					{
						on:APPLY,
						do:[ REFRESH, APPLY ],
						to:"generic /data/.hackerkernel/bck_prof"
					}
				]
			}},
			{ SDescription:{
				description:"NOTE: After you restore a profile, you have to press the X button on top to load the settings."
			}},
			{ SButton:{
				label:"Restore Selected Profile",
				action:"restorebackup applyprofile",
				notify:[
					{
						on:APPLY,
						do:[ REFRESH, APPLY ],
						to:"restorebackup pickprofile"
					}
				]
			}},
			{ SButton:{
				label:"Delete Selected Profile",
				action:"restorebackup delprofile",
				notify:[
					{
						on:APPLY,
						do:[ REFRESH, APPLY ],
						to:"restorebackup pickprofile"
					}
				]
			}},
		{ SPane:{
			title:"Configs"
		}},
			{ SOptionList:{
				title:"Selected Config",
				description:"Choose the settings you want and apply your choice in Synapse before using the action buttons below.",
				action:"restorebackup pickconfig",
				default:"None",
				values:[ "None",
					`for BAK in \`res/synapse/actions/restorebackup listconfig\`; do
						echo "\"$BAK\","
					done`
				],
				notify:[
					{
						on:APPLY,
						do:[ REFRESH, APPLY ],
						to:"generic /data/.hackerkernel/bck_prof"
					}
				]
			}},
			{ SDescription:{
				description:"NOTE: After you restore a config, you have to press the X button on top to load the settings."
			}},
			{ SButton:{
				label:"Import Selected Config",
				action:"sqlite ImportConfigSynapse",
				notify:[
					{
						on:APPLY,
						do:[ REFRESH, APPLY ],
						to:"restorebackup pickconfig"
					}
				]
			}},
			{ SButton:{
				label:"Delete Selected Config",
				action:"restorebackup delconfig",
				notify:[
					{
						on:APPLY,
						do:[ REFRESH, APPLY ],
						to:"restorebackup pickconfig"
					}
				]
			}},
		{ SPane:{
			title:"Backup Actions"
		}},
			{ SGeneric:{
				title:"Profile/Config Name",
				default:"None",
				action:"generic /data/.hackerkernel/bck_prof",
			}},
			{ SDescription:{
				description:"First set a name above and apply. After this you can press the Backup Current Profile or Export Current Config button below."
			}},
			{ SButton:{
				label:"Backup Current Profile",
				action:"restorebackup keepprofile",
				notify:[
					{
						on:APPLY,
						do:[ REFRESH, APPLY ],
						to:"generic /data/.hackerkernel/bck_prof"
					}
				]
			}},
			{ SButton:{
				label:"Export Current Config",
				action:"sqlite ExportConfigSynapse",
				notify:[
					{
						on:APPLY,
						do:[ REFRESH, APPLY ],
						to:"generic /data/.hackerkernel/bck_prof"
					}
				]
			}},
		{ SPane:{
			title:"General Actions",
			description:"To update/refresh lists, select Restart Synapse below."
		}},
			{ SButton:{
				label:"Restart Synapse",
				action:"restorebackup restart"
			}},
    ]
}
CTAG
