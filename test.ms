clearListener(); print("Cleared in:\n"+getSourceFileName())
/*
Swap local transform (rotation/position/both) between two objects
Read values at time_from, paste swapped at time_to
Only selected transform channels get keys
*/
function swapLocalTransform obj_A obj_B time_from time_to mode:#rotation =
(
	format "\n"; print ("TransformFlipper_v.swapLocalTransform() mode:" + (mode as string))
	time_from = time_from as time
	time_to   = time_to   as time
	
	/* store parents */
	parentA = obj_A.parent
	parentB = obj_B.parent
	
	localRotA = undefined
	localRotB = undefined
	localPosA = undefined
	localPosB = undefined
	
	/* read transforms at source time */
	at time time_from
	(
		if mode == #rotation or mode == #both then
		(
			localRotA = if parentA != undefined then (inverse parentA.rotation * obj_A.rotation) else obj_A.rotation
			localRotB = if parentB != undefined then (inverse parentB.rotation * obj_B.rotation) else obj_B.rotation
		)
		
		if mode == #position or mode == #both then
		(
			localPosA = if parentA != undefined then (obj_A.position * inverse parentA.transform) else obj_A.position
			localPosB = if parentB != undefined then (obj_B.position * inverse parentB.transform) else obj_B.position
		)
	)
	
	/* paste swapped transforms at target time */
	with animate on
	at time time_to
	(
		if mode == #rotation or mode == #both then
		(
			if parentA != undefined then
				obj_A.rotation = parentA.rotation * localRotB
			else
				obj_A.rotation = localRotB
			
			if parentB != undefined then
				obj_B.rotation = parentB.rotation * localRotA
			else
				obj_B.rotation = localRotA
		)
		
		if mode == #position or mode == #both then
		(
			if parentA != undefined then
				obj_A.position = (localPosB * parentA.transform)
			else
				obj_A.position = localPosB
			
			if parentB != undefined then
				obj_B.position = (localPosA * parentB.transform)
			else
				obj_B.position = localPosA
		)
	)
	-- return
)

alTransform a b 0f 40f mode:#both


/*
Swap local rotation between two objects, copy at one time, paste at another time
*/
function swapLocalRotation obj_A obj_B time_from time_to =
(
	format "\n"; print "TransformFlipper_v.swapLocalRotation()"
	time_from = time_from as time
	time_to   = time_to   as time
	
	/* store parents */
	parentA = obj_A.parent
	parentB = obj_B.parent
	
	/* KEEP POS at paste time */
	at time time_to
	(
		pos_A = obj_A.pos
		pos_B = obj_B.pos
	)
	
	/* compute local rotations at source time */
	at time time_from
	(
		localRotA = if parentA != undefined then (inverse parentA.rotation * obj_A.rotation) else obj_A.rotation
		localRotB = if parentB != undefined then (inverse parentB.rotation * obj_B.rotation) else obj_B.rotation
	)
	
	/* paste swapped rotations at target time */
	with animate on
	at time time_to
	(
		if parentA != undefined then
			obj_A.rotation = parentA.rotation * localRotB
		else
			obj_A.rotation = localRotB
		
		if parentB != undefined then
			obj_B.rotation = parentB.rotation * localRotA
		else
			obj_B.rotation = localRotA
		
		/* RESTORE POS */
		obj_A.pos = pos_A
		obj_B.pos = pos_B
	)
	-- return
)

/* ------------------ TEST ------------------ */

a = selection[1]
b = selection[2]
--b.rotation = eulerangles 0 90 0

-- read rotation at frame 0, paste swapped at frame 20
--swapLocalRotation a b 1 4

format "selection[1].rotation: %\n" ( quatToEuler( selection[1].rotation ))
format "selection[2].rotation: %\n" ( quatToEuler( selection[2].rotation ))

--a.rotation = eulerToQuat  ( 20 20 -150 )
--b.rotation = eulerToQuat  ( -160 20 -150 )


--format "rotation_angles: %\n" rotation_angles
   --in coordsys a rotate a ( EulerAngles 20 5 -150 )
   --in coordsys b rotate b ( EulerAngles -160 5 -150)
   pos_a = a.pos
   pos_b = b.pos
--   
--	a.rotation = ( EulerAngles 20 5 -150 )
--	b.rotation = ( EulerAngles -160 5 -150)
--	
--   a.pos = pos_a
--   b.pos = pos_b

--/* 
--Function to animate walk cycle of two foot controls and one master control.
--User specifies number of keys per step, step length, and steps count.
--Animates only first and last key of the step.
--*/
--function animateWalkCycle master_ctrl left_foot right_foot steps_count step_length keys_per_step =
--(
--	if (isValidNode master_ctrl and isValidNode left_foot and isValidNode right_foot) then
--	(
--		animate on
--		(
--			current_time = 0
--			step_time = keys_per_step
--			
--			half_step = step_length / 2.0
--			
--			for i = 1 to steps_count do
--			(
--				-- determine which foot moves this step
--				is_left_moving = (mod i 2 == 1)
--				
--				-- stationary foot keeps its position
--				if is_left_moving then
--				(
--					at time ( current_time ) left_foot.pos.y = half_step
--					
--					at time ( current_time ) right_foot.pos.y = -half_step
--				)
--				else
--				(
--					at time ( current_time ) right_foot.pos.y = half_step
--					
--					at time ( current_time ) left_foot.pos.y = -half_step
--				)
--				
--				current_time += step_time
--			)
--			
--			current_time = 0
--			
--			master_ctrl.pos.y = pos = step_length
--			
--			for i = 1 to steps_count do
--			(
--				pos -= step_length 
--				
--				at time (current_time) master_ctrl.pos.y = pos
--				
--				
--				current_time += step_time
--			)
--			
--		)
--	) -- return
--)
--
--
--animateWalkCycle $boy_Setup_Ctrl_MasterWalk_G $boy_Setup_Ctrl_IKFoot_L_O_1LLV $boy_Setup_Ctrl_IKFoot_R_O_1LRV 4 20 3 