
/**  
 */
macroscript AnimMaker_phase_length
category:	"_AnimMaker"
buttontext:	"[Phase Length]"
toolTip:	"Open AnimMaker"
icon:	"control:#DROPDOWN|across:2|width:48|items:#( '1', '2', '3', '4', '5', '6', '7', '8', '9')"
(
	
	format "EventFired: %\n" EventFired
)

/**  
 */
macroscript AnimMaker_phase_toggle
category:	"_AnimMaker"
buttontext:	"Phase"
toolTip:	"Open AnimMaker"
icon:	"control:#CHECKBOX|across:2"
(
	
	format "EventFired: %\n" EventFired
	
	DIALOG_content_animmaker.DL_phase_length.enabled = EventFired.val

)

/**  
 */
macroscript AnimMaker_increment
category:	"_AnimMaker"
buttontext:	"[Increment value]"
toolTip:	"Open AnimMaker"
icon:	"control:#DROPDOWN|across:2|width:48|items:#( 'Phase', '1', '2', '3', '4', '5', '6', '7', '8', '9')|height:10"
(
	format "EventFired: %\n" EventFired
	
)

/**  
 */
macroscript AnimMaker_increment_toggle
category:	"_AnimMaker"
buttontext:	"Increment"
toolTip:	"Open AnimMaker"
icon:	"control:#CHECKBOX|across:2"
(
	
	format "EventFired: %\n" EventFired
	
	DIALOG_content_animmaker.DL_increment_value.enabled = EventFired.val

)

/**  
 */
macroscript	template_make_generate
category:	"content-Template"
buttontext:	"Generate"
--toolTip:	"Generate"
icon:	"across:1|width:96|height:32|align:#CENTER"
(
	RigWrapper = RigWrapper_v()
	PhaseCreator = PhaseCreator_v()
	
	
	RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G
	
	undo "mirrorPhases" on
	
	RigWrapper.mirrorPhase ( Interval 1 3 )
)

/**  
 */
macroscript	template_mirror_phase
category:	"content-Template"
buttontext:	"Mirror"
toolTip:	"MIRROR: If 1 side is selected.\n\nSWAP: If 2 side is selected.\n\nE.G.:\n\nA) Left foot selected > MIRROR to rigt foot.\n\nB) Both feet selected > SWAP left <-> right"
icon:	"across:1|width:96|height:32|align:#CENTER"
(
	--RigWrapper = RigWrapper_v()
	--PhaseCreator = PhaseCreator_v()
	--
	--
	--RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G
	--
	--undo "mirrorPhases" on
	--
	--RigWrapper.mirrorPhase ( Interval 1 3 )
)





