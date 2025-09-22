clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/Lib/COLOR_NAMES/COLOR_NAMES.ms" )	--"./Lib/COLOR_NAMES/COLOR_NAMES.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/LHrigWrapper/LHrigWrapper.ms" )	--"./Lib/LHrigWrapper/LHrigWrapper.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/KeyFrameManager/KeyFrameManager.ms" )	--"./Lib/KeyFrameManager/KeyFrameManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/frameButtonRcMenu/frameButtonRcMenu.ms" )	--"./Lib/frameButtonRcMenu/frameButtonRcMenu.ms"


global DIALOG_time_slider_tools

/* 
	Struct: TimeSliderTools_v
	Functions for working with Time Slider and animation ranges
*/
struct TimeSliderTools_v
(
	/* constuct */ 
	_rollout,
	
	/* properties */
	green_color = COLOR_NAMES[#DARKGREEN], -- coor active frame button 
	
	/** On timer tick
	 */
	function onTimerTick is_playing_now =
	(
		--format "\n"; print "TimeSliderTools_v.onTimerTick()"
		--_rollout.status_bar.visible = true
		--format "TEST: %\n" (_rollout.slider_current_time.value != sliderTime )
		--format "_rollout.status_bar.visible: % ANIMATIONMODE: %\n" _rollout.status_bar.visible animButtonState 
		_rollout.status_bar.visible = animButtonState
		
		
		if is_playing_now then
			this.setNextFrame()
		
		else
			if _rollout.slider_current_time.value != sliderTime.frame then
				this.setFrame sliderTime.frame
		
		/*
		   AUTO FILTER KEYS ON TIME SLIDER
		  
			https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-5120D063-E771-4700-98FF-60E4E578BE52
		*/ 
		trackbar.filter = if toolmode.commandmode == #ROTATE or toolmode.commandmode == #MOVE then
			#currentTM
			--#TMOnly 
		else
			#all
		--format "_rollout: %\n" _rollout.status_bar
		
	),
	
	/** Set interval
	 */
	function setInterval val =
	(
		--format "\n"; print "TimeSliderTools_v.setInterval()"
		--format "val: %\n" val
		--format "EventFired: %\n" EventFired
		
		fps = _rollout.DL_fps.items[val] as integer

		_rollout.clock.interval = 1000 / fps
	),
	
	/** Set next frame
	 */
	function setNextFrame =
	(
		--format "\n"; print "TimeSliderTools_v.setNextFrame()"
			if sliderTime >= animationRange.end.frame then
			sliderTime = animationRange.start.frame 
		else
			sliderTime += 1
			
		this.setFrame sliderTime.frame
	),
	
	/* Is in range */
	function isInRange frame =
	(
		frame >= animationRange.start.frame and frame <= animationRange.end.frame
	),
	
	
	/* set frame */ 
	function setFrame frame =
	(
		--format "\n"; print "TimeSliderTools_v.setFrame()"
		--format "frame: %\n" frame
		
		/** Get frame button color
		 */
		function getFrameButtonColor frame =  if animButtonState then red else ( if frame > 0 then green_color else orange )
		
		frame = frame as integer
		
		if not this.isInRange(frame) then
			return false
		
		buttons = this.getFrameButtons()
		--if btn_current_frame == undefined then
		btn_current_frame = buttons[frame]
		
		sliderTime = frame
		
		/*------------------------------------------------------------------------------
			SYNC CONTROLS 
		--------------------------------------------------------------------------------*/
		
		/* ENABLE CURRENT FRAME BUTTON */ 
		--btn_current_frame = getFrameButton frame
		--btn_current_frame = getFrameButton frame
		
		if btn_current_frame != undefined then
		(
			btn_current_frame.state   = true
			
			btn_current_frame.visible = true
			
			btn_current_frame.highlightColor = getFrameButtonColor frame
			
		)

		/* DISBALE OTHER FRAME BUTTONS */ 
		for key in sort buttons.keys where key != frame do
		(
			buttons[key].state = false
			
			buttons[key].highlightColor =  getFrameButtonColor frame
		)
		
		/* SLIDER */ 
		_rollout.slider_current_time.value = frame
	),
	

	/* Show / hide buttons in range (logic placeholder, UI removed) */
	function showHideButtonsInRange frame =
	(
		-- originally changed button visibility, now only logic kept
		
		buttons = this.getFrameButtons()
		
		for frame_of_button in sort buttons.keys where frame_of_button != frame do
			buttons[frame_of_button].visible = this.isInRange frame_of_button
	),
	
	
	/* Go to frame
	 * 
	 * @param -1|1 direction 
	*/
	function jumpToPhase direction =
	(
		--format "\n"; print "TimeSliderTools_v.jumpToPhase()"
		--format "EventFired: %\n" EventFired
		--direction = if EventFired.type == #rightClick  then -1 else 1
		
		frames_increment = _rollout.DL_phase.items[ _rollout.DL_phase.selected as integer ] as integer
		
		next_frame = sliderTime.frame + (frames_increment * direction )
		
		if this.isInRange(next_frame) then
			this.setFrame next_frame
	),

	/* Update anim range buttons (UI removed) */
	function updateAnimRangeButtons =
	(
		_rollout.btn_range_start.text = ( (animationRange.start.frame as integer ) as string )

		_rollout.btn_range_end.text   = ( (  animationRange.end.frame as integer ) as string )
	),
	
	/* Set anim range */
	function setAnimRange start_or_end frame =
	(
		--format "\n"; print "TimeSliderTools_v.setAnimRange()"
		
		local _Interval
			
		
		if not keyboard.controlPressed then
		(
			_Interval = if start_or_end == #START then Interval frame (animationRange.end.frame) else Interval (animationRange.start.frame) frame
	
			--format "TEST: %\n" (_Interval.start.frame as integer == _Interval.end.frame as integer )
			/* Prevent zero length anim range */
			--format "_INTERVAL: %\n" _Interval
			
			if _Interval.start.frame as integer == _Interval.end.frame as integer then
				 _Interval.end += 1
			
		)
		else
		(
			local last_frame_button
			
			buttons = this.getFrameButtons()
			--format "buttons: %\n" buttons
			for i = buttons.keys.count - 1 to 0 by -1  do
			--format "buttons[i]: %\n" buttons[i].visible
			
			for i = buttons.keys.count - 1 to 0 by -1 while last_frame_button == undefined where buttons[i].visible do last_frame_button = buttons[i]
			--format "last_frame_button: %\n" last_frame_button
			frame_start = animationRange.start.frame
			frame_end = animationRange.end.frame
			
			 if start_or_end == #END then
				frame_end = last_frame_button.text as integer
			else
				frame_start = _rollout.btn_range_start.text as integer
			
			
			_Interval = Interval frame_start frame_end
		)
		
		
		if currentTime == animationRange.start or currentTime == animationRange.end then
			shift_frame = _Interval.start.frame
		
		--format "_INTERVAL: %\n" _Interval
		/* Set new animation range */
		animationRange = _Interval
		
		/* Show / Hide buttons */
		this.showHideButtonsInRange sliderTime.frame
		
		/* Update range buttons (UI removed) */
		this.updateAnimRangeButtons()
		--format "SHIFT_FRAME: %\n" shift_frame
		if shift_frame != undefined and not this.isInRange(shift_frame) then 
			this.setFrame shift_frame
	),
	




	--function getFrameButton frame = execute ("dialog_trackbar_tools.btn_frame_"+ (frame as integer ) as string )

	/** Get frame buttons
	 */
	function getFrameButtons =
	(
		--format "\n"; print ".getFrameButtons()"
		buttons	=  Dictionary #INTEGER
		--format "_rollout.controls: %\n" _rollout.controls
		--for ctrl in _rollout.controls do
		--format "ctrl: %\n" ctrl
		
		--buttons = for ctrl in _rollout.controls where matchPattern ctrl.name pattern:("btn_frame_*") collect ctrl
		only_frame_buttons = for ctrl in _rollout.controls where matchPattern (ctrl as string ) pattern:("*btn_frame_*") collect ctrl
		
		for i = 0 to only_frame_buttons.count - 1 collect buttons[i] = only_frame_buttons[i +1]
		
		buttons --return
	),
	
	
	on create do
	(
		this.setAnimRange animationRange.start animationRange.end
		
		this.showHideButtonsInRange currentTime
		
		this.setFrame currentTime
	)
)

-- Example usage:
-- tools = TimeSliderTools_v()
-- tools.jumpToFrame 5
filein( getFilenamePath(getSourceFileName()) + "/TimeSliderToolsDialog.ms" )	--"./TimeSliderToolsDialog.ms"
