

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
toolTip:	"Count of frames in phase"
icon:	"control:#DROPDOWN|across:2|width:64|items:#( '1', '2', '3', '4', '5', '6', '7', '8', '9')"
(
	
	format "EventFired: %\n" EventFired
)

/**  
 */
macroscript AnimMaker_phase_toggle
category:	"_AnimMaker"
buttontext:	"Phase"
toolTip:	"Enable \ Diasable Phase"
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
toolTip:	"Offset from current frame where new keys are kreated.\n\nOPTION 'Phase': Increment by phase length"
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
toolTip:	"Enable \ Diasable Increment"
icon:	"control:#CHECKBOX|across:2"
(
	
	format "EventFired: %\n" EventFired
	
	DIALOG_content_animmaker.DL_increment_value.enabled = EventFired.val

)

/*------------------------------------------------------------------------------
	BUTTONS 
--------------------------------------------------------------------------------*/


/** Get phase - nuber of frames before current time
	
	[phase keys][currentTime]
	
	@return Point2 [ start time, end time ]
  
 */
function getPhaseRange =
(
	--format "\n"; print ".getPhaseRange()"
	--end = currentTime.frame as integer 
	
	--start = end + DIALOG_content_animmaker.DL_phase_length.selected as integer + 1
	
	start = currentTime.frame as integer
	
	end = start + DIALOG_content_animmaker.DL_phase_length.selected as integer - 1


	[ start, end ] --return
)

/** Get cycle range
 */
function getCycleRange =
(
	--format "\n"; print ".getCycleRange()"
	phase = getPhaseRange()
	
	cycle = copy phase
	
	cycle.y += cycle.y - cycle.x + 1
	
	cycle --return
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

	
	PhaseCreator = PhaseCreator_v()
	
	undo "Mirror Phase" on
	(
		increment = DIALOG_content_animmaker.DL_increment_value.selected as integer
		
		rig_name = DIALOG_content_animmaker.DL_rig_select.selected
		
		phase = getPhaseRange()
		
		if (trimLeft(rig_name)).count > 0 then
			(RigWrapper_v(rig_name)).mirrorPhase phase increment:increment

		else
			(KeyFrameManager_v()).copyKeys time:phase transforms:true properties:false -- default increment is length ofrange + 1

	)
)

/**  
 */
macroscript	template_copy_phase
category:	"_AnimMaker"
--buttontext:	"Frame - > Phase"
buttontext:	"C O P Y phase \ cycle"
toolTip:	"Copy phase"
icon:	"across:1|width:128|height:32|border:false"
(

	undo "Copy phase" on
		(KeyFrameManager_v( getPhaseRange() )).copyKeys objs:( selection as Array )
)
/**  
 */
macroscript	template_copy_cycle
category:	"_AnimMaker"
--buttontext:	"Frame - > Phase"
buttontext:	"C O P Y phase \ cycle"
toolTip:	"Copy cycle - 1 cycle == 2 phases"
icon:	"across:1|width:128|height:32|border:false"
(

	undo "Copy cycle" on
	--format "getCycleRange(): %\n" (getCycleRange())
		(KeyFrameManager_v( getCycleRange() )).copyKeys objs:( selection as Array )
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





