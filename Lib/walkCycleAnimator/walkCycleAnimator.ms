/** Walk cycle animator
 */
struct WalkCycleAnimator_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	/** Animate walk on rig
	 */
	function animateWalkOnRig rig_name steps_count step_length keys_per_step =
	(
		format "\n"; print ".animateWalkOnRig()"
		--format "DIALOG_time_slider_tools.DL_rig.items: %\n" DIALOG_time_slider_tools.DL_rig.items
		--format "DIALOG_time_slider_tools.DL_rig.selected: %\n" DIALOG_time_slider_tools.DL_rig.selected
		--rig_name = DIALOG_time_slider_tools.DL_rig.selected
		format "rig_name: %\n" rig_name
		
		steps_count	= steps_count as integer
		step_length	= step_length as integer
		keys_per_step	= keys_per_step as integer
		format "steps_count: %\n" steps_count
		format "step_length: %\n" step_length
		format "keys_per_step: %\n" keys_per_step
		LHrigWrapper = LHrigWrapper_v()
		
		master_ctrl = LHrigWrapper.getControlObject rig_name "MasterWalk"
		
		foot_left  = LHrigWrapper.getControlObject rig_name "IKFoot_L"
		foot_right = LHrigWrapper.getControlObject rig_name "IKFoot_R"
		
		format "master_ctrl: %\n" master_ctrl
		format "foot_left: %\n" foot_left
		format "foot_right: %\n" foot_right
		
					--rig_controllers = execute ("$'*_Setup_Ctrl_*'") as Array
		this.animateWalkCycle master_ctrl[1] foot_left[1] foot_right[1] steps_count step_length keys_per_step
	),
	
	
	/* 
	Function to animate walk cycle of two foot controls and one master control.
	User specifies number of keys per step, step length, and steps count.
	Animates only first and last key of the step.
	*/
	function animateWalkCycle master_ctrl left_foot right_foot steps_count step_length keys_per_step =
	(
		if (isValidNode master_ctrl and isValidNode left_foot and isValidNode right_foot) then
		(
			animate on
			(
				current_time = 0
				step_time = keys_per_step
				
				half_step = step_length / 2.0
				
				for i = 1 to steps_count do
				(
					-- determine which foot moves this step
					is_left_moving = (mod i 2 == 1)
					
					-- stationary foot keeps its position
					if is_left_moving then
					(
						at time ( current_time ) left_foot.pos.y = half_step
						
						at time ( current_time ) right_foot.pos.y = -half_step
					)
					else
					(
						at time ( current_time ) right_foot.pos.y = half_step
						
						at time ( current_time ) left_foot.pos.y = -half_step
					)
					
					current_time += step_time
				)
				
				current_time = 0
				
				master_ctrl.pos.y = pos = step_length
				
				for i = 1 to steps_count do
				(
					pos -= step_length 
					
					at time (current_time) master_ctrl.pos.y = pos
					
					
					current_time += step_time
				)
				
			)
		) -- return
	),
	
	private
	

	/**
	 */
	on create do
	(
		--format "\n"; print "WalkCycleAnimator.onCreate()"
	)
)

