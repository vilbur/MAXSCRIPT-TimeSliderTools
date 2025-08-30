
/** Time slider tools dialog
 */
function timeSliderToolsDialog =
(
	format "\n"; print ".timeSliderToolsDialog()"

	
	/* SETUP */
	
	width_groupbox   = 96
	width_groupbox_2 = width_groupbox * 2
 
	width_button	= 36
	width_btn_big	= 84
	height_btn_big	= 40
	width_btn_small	= 24
	frame_range	= 16 -- 0-16th frame
	frame_buttons = frame_range + 1
	
	across = frame_buttons + 1
	
	align_slider_to_buttons = 6 -- offset for pixel perfect postion of slider
	
	buttons_margin = 2 * width_button
	
	width_slider	= width_button * frame_range + ( width_button / 2) + align_slider_to_buttons

	dialog_width = width_groupbox_2 + width_slider + buttons_margin - ( width_button / 2)
	dialog_height = 96
	
	
	
	/* DIALOG */
	Dialog 	    = Dialog_v ("Time Slider Tools") width:(dialog_width + 0 )
	--Dialog 	    = Dialog_v ("Test") --ini:(getSourceFileName())
	
	/* DIALOG CONTROLS */  
	_Controls   = Dialog.Controls height:256
	--_Button      = _Controls.control #BUTTON "Btn" 
	--
	--_Controls2   = Dialog.Controls group:("Main Controls2 " )
	--_Button      = _Controls2.control #BUTTON "Btn 2" 
	
	
	_left   = _Controls.control #GroupBox "" id:#FRAMES_CONTROLS	width:width_groupbox pos:[ 0, 0 ]
	_right  = _Controls.control #GroupBox "" id:#PHASE_CONTROLS	width:width_groupbox pos:[ dialog_width - width_groupbox, 0 ]
	
	--_GroupBox = _Controls.control #GroupBox "groupbox_nameX" params:#( #height, 196 ) across:2
	
	/* LEFT GROUPBOX  */ 
	_Controls.control #BUTTON "PLAY"	groupbox:_left.id across:1 width:width_btn_bigs height:height_btn_big offset:[ 0, -16 ] 
	_Controls.control #LABEL "FPS"	groupbox:_left.id across:2 align:#LEFT  offset:[ 0, 10 ] 
	_Controls.control #DROPDOWN "[FPS]"	groupbox:_left.id across:2 align:#RIGHT offset:[ 6, 8 ]  width:48  offset:[ 0, 8 ] items:#( "24", "12", "6", "4", "2", "1" ) value:4 
	--_Controls.control #SPINNER "FPS"	groupbox:_left.id across:1 align:#LEFT
	

	/* RIGHT GROUPBOX  */ 
	_Controls.control #BUTTON "SWITCH"	groupbox:_right.id across:1 width:width_btn_big height:height_btn_big offset:[ 0, -16 ] 
	_Controls.control #LABEL "PHASE"	groupbox:_right.id across:2 align:#LEFT  offset:[-6, 10 ] 
	_Controls.control #DROPDOWN "[Phase]"	groupbox:_right.id across:2 align:#RIGHT offset:[ 6, 8 ]  width:44  offset:[ 0, 8 ] items:#( "2", "3", "4", "5", "6", "7", "8", "9", "10" ) value:42

	--	
	pos_x_origin = pos_x = width_groupbox + 4
	
	pos_y = 4
	
	
	pos_x_button =  pos_x_origin - ( width_button / 2 )

	_Srart  = _Controls.control #BUTTON "0"	id:#btn_range_start	 width:width_btn_small	height:32	pos:[ pos_x, pos_y + 4 ]
	_Slider = _Controls.control #SLIDER ""	id:#slider_current_time	 width:width_slider	type:#integer	pos:[ pos_x += width_button - align_slider_to_buttons , pos_y ]  range:[0, frame_range, 0] ticks:frame_range
	_End    = _Controls.control #BUTTON "1"	id:#btn_range_end	 width:width_btn_small	height:32	pos:[ pos_x += width_slider - align_slider_to_buttons,  pos_y + 4 ]
	
	
	/** Get highlight color
	 */
	function getHighlightColor =
	(
		--format "\n"; print ".getHighlightColor()"
	)
	
	
	/* SHOFT BUTTON DOWN */ 
	pos_y += width_button
	
	/* ADD BUTTONS  */ 
	for i = 0 to frame_range do
		_Button = _Controls.control #CHECKBUTTON ( i as string ) width:width_button height:width_button pos:[ pos_x_button += width_button , pos_y ] highlightColor:(if i == 0 then orange )
	
	
	
	

	--
	--/* ROLLOUTS */
	--_Rollouts	 = Dialog.Rollouts()
	--
	--/* ROLLOUT */
	--_Rollout    = _Rollouts.Roll "Subrollout"
	
	--_Controls   = _Rollout.Controls group:"Rollout Controls"
	--_Button     = _Controls.control #BUTTON "Rollout" id:#button_2
	
	
	--
	--/* SUBROLLOUTS */
	--Subrollouts = _Rollout.Rollouts()
	--
	--/* SUBROLLOUT */
	--_Subrollout = Subrollouts.Roll "Nested"
	--_Controls    = _Subrollout.Controls group:"Subrollout Controls"
	--_Button      = _Controls.control #BUTTON "Subrollout" id:#button_3
	--
	--
	--/* DIALOG BOTTOM */
	--_Controls   = Dialog.Controls group:"Main Controls Bottom"
	--_Button     = _Controls.control #BUTTON "Bottom" id:#button_4
	
	
	/* DIALOG CREATE */
	--Dialog.create()
	Dialog.create height:dialog_height lockHeight:true
	
	Dialog.register()
)
