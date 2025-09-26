clearListener(); print("Cleared in:\n"+getSourceFileName())



/* 
Function to animate single foot step
Animates only first and last key of the step
*/
function animateFootStep foot stepLength=20 t=0 keySpacing=10 =
(
	local basePos = foot.pos
	at time t (foot.pos = basePos)                               -- start key
	at time (t + keySpacing) (foot.pos = basePos + [stepLength,0,0]) -- end key
	-- return
)

/* 
Function to animate hip key following foot
Hip is keyed only on every second step
*/
function animateHipStep hip foot t=0 keySpacing=10 =
(
	at time (t + keySpacing) (hip.pos = foot.pos)
	-- return
)

/* 
Function to animate walk cycle of two foot controls and one hip control
Each foot is animated in turn, hip follows only every second step
*/
function animateWalk footA footB hip stepLength=20 stepCount=5 keySpacing=10 =
(
	animate on
	(
		local t = 0
		local feet = #(footA, footB)

		for s = 1 to stepCount do
		(
			for f = 1 to feet.count do
			(
				local foot = feet[f]
				animateFootStep foot stepLength t keySpacing

				-- hip keys only on every second step
				if ((s-1)*2 + f) mod 2 == 0 then
					animateHipStep hip foot t keySpacing

				t += keySpacing
			)
		)
	)
	-- return
)

/* 
Example usage:
animateWalk $Foot_L $Foot_R $Hip stepLength=30 stepCount=4
*/
animateWalk $boy_Setup_Ctrl_IKFoot_L_O_1LLV $boy_Setup_Ctrl_IKFoot_R_O_1LRV $boy_Setup_Ctrl_MasterWalk_G stepLength=20 stepCount=4
