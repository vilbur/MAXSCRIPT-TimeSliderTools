

--/**  
-- */
--macroscript AnimMaker_rig_choose
--category:	"_AnimMaker"
--buttontext:	"RIG"
--toolTip:	"Open AnimMaker"
--icon:	"control:#DROPDOWN|across:2|width:64|items:#( 'Phase', '1', '2', '3', '4', '5', '6', '7', '8', '9')|height:10"
--(
--	format "EventFired: %\n" EventFired
--	
--)


/**  
 */
macroscript AnimMaker_rig
category:	"_AnimMaker"
buttontext:	"[Rig select]"
toolTip:	""
icon:	"control:#DROPDOWN|across:1|width:128"
(
	
	format "EventFired: %\n" EventFired
)

/*------------------------------------------------------------------------------
	PHASE
--------------------------------------------------------------------------------*/


/**  
 */
macroscript AnimMaker_phase_length
category:	"_AnimMaker"
buttontext:	"[Phase Length]"
toolTip:	"Open AnimMaker"
icon:	"control:#DROPDOWN|across:2|width:64|items:#( '1', '2', '3', '4', '5', '6', '7', '8', '9')"
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

/*------------------------------------------------------------------------------
	INCREMENT
--------------------------------------------------------------------------------*/

/**  
 */
macroscript AnimMaker_increment
category:	"_AnimMaker"
buttontext:	"[Increment value]"
toolTip:	"Open AnimMaker"
--icon:	"control:#DROPDOWN|across:2|width:64|items:#( 'Phase', '1', '2', '3', '4', '5', '6', '7', '8', '9')"
icon:	"control:#DROPDOWN|across:2|width:64|items:#( 'Phase', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9')"
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

/*------------------------------------------------------------------------------
	BUTTONS 
--------------------------------------------------------------------------------*/



/**  
 */
macroscript	template_make_generate
category:	"content-Template"
--buttontext:	"Frame - > Phase"
buttontext:	"Mirror phase"
toolTip:	"Generate phase from single frame.E.G.: Generate 1st step from first frame"
icon:	"across:1|width:128|height:32|border:false"
(
	
	/** Get interval
	 */
	function getPhaseLenght =
	(
		--format "\n"; print ".getPhaseLenght()"
		start = currentTime.frame as integer
		
		end = start + DIALOG_content_animmaker.DL_phase_length.selected as integer - 1
		format "Interval: %\n" (Interval start end)
		Interval start end --return
	)

	
	RigWrapper = RigWrapper_v()
	PhaseCreator = PhaseCreator_v()
	
	
	RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G
	
	undo "Frame - > Phase" on
		RigWrapper.mirrorPhase (getPhaseLenght()) increment:DIALOG_content_animmaker.DL_increment_value.selected
)

/**  
 */
macroscript	template_repeat_phase
category:	"content-Template"
buttontext:	"Repeat Phase"
toolTip:	""
icon:	"across:1|width:128|height:32|border:false"
(
	
	/** Get interval
	 */
	function getPhaseLenght =
	(
		--format "\n"; print ".getPhaseLenght()"
		start = currentTime.frame as integer
		
		end = start + DIALOG_content_animmaker.DL_phase_length.selected as integer - 1
		format "Interval: %\n" (Interval start end)
		Interval start end --return
	)
	
	--RigWrapper = RigWrapper_v()
	PhaseCreator = PhaseCreator_v()
	
	PhaseCreator_v.repeatPhase( selection as Array )
	
	
)


--/**  
-- */
--macroscript	template_mirror_phase
--category:	"content-Template"
--buttontext:	"Mirror phase"
--toolTip:	"MIRROR: If 1 side is selected.\n\nSWAP: If 2 side is selected.\n\nE.G.:\n\nA) Left foot selected > MIRROR to rigt foot.\n\nB) Both feet selected > SWAP left <-> right"
--icon:	"across:1|width:128|height:32|border:false"
--(
--	--RigWrapper = RigWrapper_v()
--	--PhaseCreator = PhaseCreator_v()
--	--
--	--
--	--RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G
--	--
--	--undo "mirrorPhases" on
--	--
--	--RigWrapper.mirrorPhase ( Interval 1 3 )
--)
--
--/**  
-- */
--macroscript	template_make_cycle
--category:	"content-Template"
--buttontext:	"Cycle"
--toolTip:	""
--icon:	"across:1|width:128|height:32|border:false"
--(
--	--RigWrapper = RigWrapper_v()
--	--PhaseCreator = PhaseCreator_v()
--	--
--	--
--	--RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G
--	--
--	--undo "mirrorPhases" on
--	--
--	--RigWrapper.mirrorPhase ( Interval 1 3 )
--)





