clearListener(); print("Cleared in:\n"+getSourceFileName())


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
)


animateWalkCycle $boy_Setup_Ctrl_MasterWalk_G $boy_Setup_Ctrl_IKFoot_L_O_1LLV $boy_Setup_Ctrl_IKFoot_R_O_1LRV 4 20 3 