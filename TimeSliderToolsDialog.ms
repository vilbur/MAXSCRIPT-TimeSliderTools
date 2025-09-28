
/** Time slider tools dialog
 */
function timeSliderToolsDialog =
(
	format "\n"; print ".timeSliderToolsDialog()"

	
	/* SETUP */
	
	width_groupbox   = 96
	width_groupbox_2 = width_groupbox * 3
 
	width_button	= 36
	width_btn_big	= 84
	height_btn_big	= 40
	width_btn_small	= 24
	frame_range	= 16 -- 0-16th frame
	frame_buttons = frame_range + 1
	
	--margin = 4
	across = frame_buttons + 1
	
	align_slider_to_buttons = 6 -- offset for pixel perfect postion of slider
	
	buttons_margin = 2 * width_button
	
	width_slider	= width_button * frame_range + ( width_button / 2) + align_slider_to_buttons

	dialog_width = width_groupbox_2 + width_slider + buttons_margin - ( width_button / 2)
	
	dialog_height = 80
	
	--id = #DIALOG_time_slider_tools
	 
	/* DIALOG */
	Dialog 	    = Dialog_v ("Time Slider Tools") width:(dialog_width + 0 ) ini:(getSourceFileName())
	--Dialog 	    = Dialog_v ("Test") --ini:(getSourceFileName())
	
	dialog_id = Dialog.id as string 
	
	Dialog.Event #OPEN ("TimeTools = TimeSliderTools_v("+Dialog.id as string +")")	tooltip:"PRESSED Tooltip"

	/* DIALOG CONTROLS */  
	_Controls   = Dialog.Controls height:256
	--_Button      = _Controls.control #BUTTON "Btn" 
	--
	--_Controls2   = Dialog.Controls group:("Main Controls2 " )
	--_Button      = _Controls2.control #BUTTON "Btn 2" 
	Dialog.addLocal "TimeTools" undefined
	
	Dialog.addLocal "is_playing_now" false
	
	_Timer = _Controls.control #TIMER "Timer" id:#clock interval:500 active:true
	_Timer.Event #TICK ("if TimeTools != undefined then TimeTools.onTimerTick(is_playing_now)")

	bar   = _Controls.control #imgTag "" id:#status_bar color:red width:dialog_width height:1 across:1 pos:[0,0] visible:false --align:#CENTER
	
	
	/*------------------------------------------------------------------------------
		GROUPBOXES
	------------------------------------------------------------------------------*/
	gb_play	= _Controls.control #GroupBox "" id:#FRAMES_CONTROLS	width:width_groupbox pos:[ 0, 1 ] across:3
	gb_phase	= _Controls.control #GroupBox "" id:#PHASE_CONTROLS	width:width_groupbox pos:[ dialog_width - (width_groupbox * 2 ), 1 ]
	gb_anim	= _Controls.control #GroupBox "" id:#ANIMATION_GEN	width:width_groupbox pos:[ dialog_width - width_groupbox, 1 ]
	
	
	
	/*------------------------------------------------------------------------------
		PLAY GROUPBOX 
	--------------------------------------------------------------------------------*/ 
	Play	= _Controls.control #CHECKBUTTON	"P L A Y"	groupbox:gb_play.id across:1 width:width_btn_big height:height_btn_big offset:[ 0, -16 ] color:COLOR_NAMES[#DARKGREEN]
	FPS_label	= _Controls.control #LABEL	"FPS"	groupbox:gb_play.id across:2 align:#LEFT  offset:[ 0, 10 ] 
	FPS_ddl	= _Controls.control #DROPDOWN	"[FPS]"	groupbox:gb_play.id across:2 align:#RIGHT offset:[ 6, 8 ]  width:48  items:#( "24", "12", "6", "4", "2", "1" ) value:4 
	
	Play.Event #CHANGED "is_playing_now = not is_playing_now"	tooltip:"Play animation"
	
	FPS_ddl.Event #SELECTED  ("TimeTools.setInterval" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	--FPS_ddl.Event #ENTERED ("format \"VAL: %\n\"" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	
	/*------------------------------------------------------------------------------
		SWITCH GROUPBOX
	--------------------------------------------------------------------------------*/
	_Switch	= _Controls.control #BUTTON "S W I T C H"	groupbox:gb_phase.id across:1 width:width_btn_big height:height_btn_big offset:[ 0, -16 ] 
	_Phase_label	= _Controls.control #LABEL "PHASE"	groupbox:gb_phase.id across:2 align:#LEFT  offset:[-6, 10 ] tooltip:"Number of frames in phase"
	_Phase_ddl	= _Controls.control #DROPDOWN "[Phase]"	groupbox:gb_phase.id across:2 align:#RIGHT offset:[ 6, 8 ]  width:44   items:( for i = 1 to 10 collect i as string ) value:2 height:11
	
	--_Phase.Event #CHANGED (Dialog.id as string +".clock.interval = EventFired.val as integer" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	_Switch.Event #PRESSED ("TimeTools.jumpToPhase(-1)" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	_Switch.Event #RIGHTCLICK ("TimeTools.jumpToPhase(1)" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	
	_Phase_ddl.Event #SELECTED ("TimeTools.updateButtons(sliderTime.frame)" )  --("format \"EventFired: %\n\" EventFired " ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	
	/*------------------------------------------------------------------------------
		ANIMATOR GROUPBOX
	--------------------------------------------------------------------------------*/
	rigs_in_scene = (LHrigWrapper_v()).searchForRigsInScene()
	--format "rigs_in_scene: %\n" rigs_in_scene
	_rig_label	= _Controls.control #LABEL    "RIG"	groupbox:gb_anim.id across:2 align:#LEFT  offset:[-4, -6 ] tooltip:""
	_rig_ddl	= _Controls.control #DROPDOWN "[RIG]"	groupbox:gb_anim.id across:2 align:#RIGHT offset:[ 12, -12 ] width:64 items:rigs_in_scene height:(rigs_in_scene.count +1)
	
	_step_length	= _Controls.control #SPINNER  "Step"	groupbox:gb_anim.id across:2  align:#LEFT  fieldwidth:24 offset:[ -6, 0 ] range:[10,1000,10]  tooltip:"Length of step" type:#INTEGER
	_step_count	= _Controls.control #SPINNER  "[steps count]"	groupbox:gb_anim.id across:2  align:#RIGHT fieldwidth:24 offset:[ 12, 0 ] range:[1,10,4]  tooltip:"Count of steps" type:#INTEGER
	_walk	= _Controls.control #BUTTON   "WALK"	groupbox:gb_anim.id across:1 width:width_btn_big  offset:[ 0, 0 ] --height:height_btn_big


	--_walk.Event #PRESSED ("(WalkCycleAnimator_v()).animateWalkOnRig("+Dialog.id as string +".DL_rig.selected )" ) --params:#("EventFired.control.selected")	--tooltip:("Set Frame " + i as string )
	_walk.Event #PRESSED ("(WalkCycleAnimator_v()).animateWalkOnRig "+ dialog_id +".DL_rig.selected " + dialog_id +".SPIN_steps_count.value " + dialog_id +".DL_phase.selected step_length:" +dialog_id +".SPIN_step.value" ) 
	--_walk.Event #PRESSED ("(WalkCycleAnimator_v()).animateWalkOnRig("+Dialog.id as string +".DL_rig.selected )" ) params:#( dialog_id +".SPIN_steps_count.value", dialog_id +".SPIN_step.value", dialog_id +".DL_phase.selected" )	
	--_walk.Event #PRESSED ("(WalkCycleAnimator_v()).animateWalkOnRig" ) params:# ( dialog_id +".DL_rig.selected", dialog_id +".SPIN_steps_count.value", dialog_id +".SPIN_step.value", dialog_id +".DL_phase.selected" )	--tooltip:("Set Frame " + i as string )

	_step_length.Event #CHANGED ("format \"EventFired: %\n\" EventFired ")	tooltip:"Play animation"

	--_Switch.Event #RIGHTCLICK ("TimeTools.jumpToPhase(1)" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
	--
	--_Phase_ddl.Event #SELECTED ("TimeTools.updateButtons(sliderTime.frame)" )  --("format \"EventFired: %\n\" EventFired " ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	
	
	
	/*------------------------------------------------------------------------------
		ORIGIN OF CONTROLS 
	--------------------------------------------------------------------------------*/
	pos_x_origin = pos_x = width_groupbox + 4
	
	pos_y = 4
	
	
	pos_x_button =  pos_x_origin - ( width_button / 2 )
	
	
	
	/*------------------------------------------------------------------------------
		SLIDER & CONTROLS 
	--------------------------------------------------------------------------------*/
	_Srart  = _Controls.control #BUTTON "0"	id:#btn_range_start	 width:width_btn_small	height:32	pos:[ pos_x, pos_y + 4 ]	tooltip:"Set Animation range START"
	_Slider = _Controls.control #SLIDER ""	id:#slider_current_time	 width:width_slider	type:#INTEGER	pos:[ pos_x += width_button - align_slider_to_buttons , pos_y ]  range:[0, frame_range, 0] ticks:frame_range
	_End    = _Controls.control #BUTTON "1"	id:#btn_range_end	 width:width_btn_small	height:32 Start:32	pos:[ pos_x += width_slider - align_slider_to_buttons,  pos_y + 4 ] tooltip:"Set Animation range END\n\nCTRL: Set RANGE END by last button"
	
	/* EVENTS */ 
	_Slider.Event #CHANGED ("TimeTools.setFrame" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	_Srart.Event #PRESSED	"TimeTools.setAnimRange #START ( animationRange.start.frame - 1 )"	tooltip:" - 1 frame"
	_Srart.Event #RIGHTCLICK	"TimeTools.setAnimRange #START ( animationRange.start.frame + 1 )"	tooltip:" + 1 frame"
	
	_End.Event #PRESSED	"TimeTools.setAnimRange #END ( animationRange.end.frame - 1 )"	tooltip:" - 1 frame"
	_End.Event #RIGHTCLICK	"TimeTools.setAnimRange #END ( animationRange.end.frame + 1 )"	tooltip:" + 1 frame"

	
	/** Get highlight color
	 */
	function getHighlightColor =
	(
		--format "\n"; print ".getHighlightColor()"
	)
	
	
	/* SHIFT BUTTON DOWN */ 
	pos_y += width_button
	
	
	
	/*------------------------------------------------------------------------------
		FRAME BUTTONS
	------------------------------------------------------------------------------*/
	for i = 0 to frame_range do
	(
		_Frame_btn = _Controls.control #CHECKBUTTON ( i as string ) id:("btn_frame_"+i as string ) width:width_button height:width_button pos:[ pos_x_button += width_button , pos_y ] highlightColor:(if i == 0 then orange else COLOR_NAMES[#DARKGREEN] )
		
		
		--_Frame_btn.Event #CHANGED ("TimeTools.setFrame( "+i as string +")( EventFired.control )") --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
		_Frame_btn.Event #CHANGED ("TimeTools.setFrame( "+i as string +")" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )
		
		_Frame_btn.Event #RIGHTCLICK ("frameButtonRcMenu( "+i as string +")" ) --params:#("EventFired.control")	tooltip:("Set Frame " + i as string )

	)
	
	
	
	/*------------------------------------------------------------------------------
		DIALOG CREATE
	------------------------------------------------------------------------------*/
	--------Dialog.create()
	Dialog.create height:dialog_height lockWidth:true lockHeight:true
	
	Dialog.register()
)

timeSliderToolsDialog()