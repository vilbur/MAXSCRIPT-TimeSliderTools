

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


/** Get interval
 */
function getPhaseRange =
(
	--format "\n"; print ".getPhaseRange()"
	start = currentTime.frame as integer
	
	end = start + DIALOG_content_animmaker.DL_phase_length.selected as integer - 1

	[ start, end ] --return
)


/**  
 */
macroscript	template_make_generate
category:	"_AnimMaker"
--buttontext:	"Frame - > Phase"
buttontext:	"M I R R O R phase"
toolTip:	"Generate phase from single frame.E.G.: Generate 1st step from first frame"
icon:	"across:1|width:128|height:32|border:false"
(

	
	RigWrapper = RigWrapper_v()
	PhaseCreator = PhaseCreator_v()
	
	
	RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G
	
	undo "Mirror Phase" on
		RigWrapper.mirrorPhase (getPhaseRange()) increment:DIALOG_content_animmaker.DL_increment_value.selected
)

/**  
 */
macroscript	template_copy_phase
category:	"_AnimMaker"
--buttontext:	"Frame - > Phase"
buttontext:	"C O P Y phase"
--toolTip:	"Generate phase from single frame.E.G.: Generate 1st step from first frame"
icon:	"across:1|width:128|height:32|border:false"
(

	
	RigWrapper = RigWrapper_v()
	PhaseCreator = PhaseCreator_v()
	
	
	RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G
	
	undo "Copy" on
		(KeyFrameManager_v( getPhaseRange() )).copyKeys objs:( selection as Array )
)

/**  
 */
macroscript	template_repeat_phase
category:	"content-Template"
buttontext:	"R E P E A T transform"
toolTip:	""
icon:	"across:1|width:128|height:32|border:false"
(
	
	--/** Get interval
	-- */
	--function getPhaseRange =
	--(
	--	--format "\n"; print ".getPhaseRange()"
	--	start = currentTime.frame as integer
	--	
	--	end = start + DIALOG_content_animmaker.DL_phase_length.selected as integer - 1
	--	format "Interval: %\n" ([ start, end] )
	--	[ start, end ] --return
	--)
	
	--RigWrapper = RigWrapper_v()
	PhaseCreator = PhaseCreator_v()
	
	PhaseCreator_v.repeatPhaseTransform( selection as Array )
	
	
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





