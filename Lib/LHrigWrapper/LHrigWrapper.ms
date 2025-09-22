filein( getFilenamePath(getSourceFileName()) + "/../RigFlipper/RigFlipper.ms" )	--"./../RigFlipper/RigFlipper.ms"

/**
 */
struct LHrigWrapper_v
(
	/* construct */
	

	/* required */
	

	/* properties */
	objs_keys	= Dictionary #STRING, -- KEY:obj.name VALUE:#(key frames to procerss)

	--controllers_to_flip = Dictionary #STRING,
	controllers_to_flip = Dictionary #STRING,
	RigFlipper = RigFlipper_v(),


	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Is rig controller
	 */
	function isRigController obj_name =
	(
		--format "\n"; print "LHrigWrapper_v.isRigController()"
		matchPattern obj_name pattern:("*_Setup_Ctrl_*")
	),
	
	/** Set controller to flip
	 */
	function setControllerToFlip obj_name =
	(
		format "\n================================================\n"
		format "\n"; print "LHrigWrapper_v.setControllerToFlip()"
		
		/*
			RESULT: #(#("boy_Setup_Ctrl_IKFoot_R_O_1LRV", "boy_Setup_Ctrl_IKFoot", "IKFoot"))

		
		*/ 		
		matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches obj_name "(.*_Setup_Ctrl_([^_]+_)).*" 
		
		result	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
		(
			format "RESULT: %\n" result
			basename = result[1][2]
			format "basename: %\n" basename
			
			fk_or_ik = if matchPattern result[1][3] pattern:("IK*") then #IK else #FK
			
			
			if controllers_to_flip[basename] == undefined then
				controllers_to_flip[basename] = 1
			else
				controllers_to_flip[basename] += 1
		)
	),
	
	/** Mirror controller transfroms
	  *
	  * 1) IF 1 controller selected then MIRROR transforms to second
	  *
	  *
	  *
	 */
	function mirrorControllerTransfroms =
	(
		format "\n\n"; print "LHrigWrapper_v.mirrorControllerTransfroms()"
		
		
		for ctrl_name in controllers_to_flip.keys where controllers_to_flip[ctrl_name] == 2 do
		(
			format "\n"
			format "ctrl_name: %\n" ctrl_name
			--select $'*_Setup_Ctrl_*'
			 --objName = controllers_to_flip[ctrl] 
			--rig_controllers = execute ("$'*_Setup_Ctrl_*'") as Array
			rig_controllers = execute ("$'"+ctrl_name+"*'") as Array
			
	--RigFlipper.processIKKeys obj_A times_A obj_B times_B

	
	

		if rig_controllers.count == 2 then
		(
			
			obj_A = rig_controllers[1]
			obj_B = rig_controllers[2]
			
			RigFlipper.mirrorTrasformsAtTimes obj_A objs_keys[obj_A.name] obj_B objs_keys[obj_B.name]
			
			
		)
			
			
			format "classOf rig_controllers: %\n" ( classOf rig_controllers )
			format "rig_controllers: %\n" rig_controllers
			format "rig_controllers.count: %\n" rig_controllers.count
			
			
			--if matchPattern ctrl_name pattern:("FK*") then
			--	this.swapLocalTransforms rig_controllers[1] rig_controllers[2]
			--
			--else if matchPattern ctrl_name pattern:("IK*") then
			--	this.flipIKControllers rig_controllers[1] rig_controllers[2]
			
		)
		
	),
	

	private
	
	
	/**
	 */
	on create do
	(
		--format "\n"; print "LHrigWrapper.onCreate()"
	)
)
