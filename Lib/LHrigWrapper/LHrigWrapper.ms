filein( getFilenamePath(getSourceFileName()) + "/../TransformFlipper/TransformFlipper.ms" )	--"./../TransformFlipper/TransformFlipper.ms"

/**
 */
struct LHrigWrapper_v
(
	/* construct */
	key_times, -- #( int ) -- times to flip

	/* required */
	

	/* properties */
	control_mane_pattern = "(.*_Setup_Ctrl_([^_]+_)).*",
	--objs_keys	= Dictionary #STRING, -- KEY:obj.name VALUE:#(key frames to procerss)

	--objs = Dictionary #STRING,
	--objs = Dictionary #STRING,
	objs = #(),
	
	TransformFlipper = TransformFlipper_v(),


	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Is rig controller
	 */
	function isRigController obj_name =
	(
		format "\n"; print "LHrigWrapper_v.isRigController()"
		format "isRigController: %\n" (matchPattern obj_name pattern:("*_Setup_Ctrl_*"))
		matchPattern obj_name pattern:("*_Setup_Ctrl_*")
	),
	
	/** Set controller to flip
	 */
	function addControllerToFlip obj =
	(
		format "\n================================================\n"
		format "\n"; print "LHrigWrapper_v.addControllerToFlip()"
		format "obj.name: %\n" obj.name
		
		if this.isRigController(obj.name) then
			append objs obj

	),
	
	/** Mirror or flip transfroms of controllers
	  * 
	  * 
	  * MIRROR:	If 1 controller of 2 pair controllers selected 
	  * FLIP:	If 2 pair controllers are selected ( E.G.: left & right  foot )
	  *
	  *
	  *
	 */
	function mirrorControllerTransfroms =
	(
		format "\n\n"; print "LHrigWrapper_v.mirrorControllerTransfroms()"
		format "KEY_TIMES: %\n" key_times
		format "this.objs: %\n" this.objs
		format "this.objs.count: %\n" this.objs.count

		
		for i = this.objs.count to 1 by -1 where ( obj = objs[i] ) != undefined do 
		(
			format "\n------------------------------------------------------------\n\n"
			format "obj: %\n" obj
			
			ObjectControllerKeys = ObjectControllerKeys_v(obj)
			
			rig_controllers = this._getObjectsWithSamePatternOfName(obj.name)
			
		--	fk_or_ik = if matchPattern result[1][3] pattern:("IK*") then #IK else #FK

			
			if rig_controllers.count == 2 then
			(
				index_first	= findItem rig_controllers obj
				
				index_pair  = findItem objs pair_obj
				
				pair_obj = rig_controllers[ if index_first == 1 then 2 else 1 ]
				
				TransformFlipper.mirrorTrasformsAtTimes (obj) (key_times) (pair_obj) (key_times)

	--		--if matchPattern ctrl_name pattern:("FK*") then
	--		--	this.swapLocalTransforms rig_controllers[1] rig_controllers[2]
	--		--
	--		--else if matchPattern ctrl_name pattern:("IK*") then
	--		--	this.flipIKControllers rig_controllers[1] rig_controllers[2]
				
				
				
				/* AVOID MIRROR SAME PAIR AGAIN */ 
				if index_pair > 0 then
					this.objs[index_pair] = undefined
					
					
				
			)
			
		)
	),
	
	/** Get objects with same pattern of name
	 */
	function _getObjectsWithSamePatternOfName obj_name =
	(
		--format "\n"; print "LHrigWrapper_v._getObjectsWithSamePatternOfName()"
		matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches obj_name control_mane_pattern -- ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase 

		/* RESULT: #(#("boy_Setup_Ctrl_IKFoot_R_O_1LRV", "boy_Setup_Ctrl_IKFoot", "IKFoot")) */ 
		result	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
		
		ctrl_name = result[1][2] --return
		
		execute ("$'"+ctrl_name+"*'") as Array --return
	),
	
	
		
		--	fk_or_ik = if matchPattern result[1][3] pattern:("IK*") then #IK else #FK
		--	
		--	
		--	if objs[basename] == undefined then
		--		objs[basename] = 1
		--	else
		--		objs[basename] += 1
		--)			
	--	for ctrl_name in objs.keys where objs[ctrl_name] == 2 do
	--	(
	--		format "\n"
	--		format "ctrl_name: %\n" ctrl_name
	--		--select $'*_Setup_Ctrl_*'
	--		 --objName = objs[ctrl] 
	--		--rig_controllers = execute ("$'*_Setup_Ctrl_*'") as Array
	--		rig_controllers = execute ("$'"+ctrl_name+"*'") as Array
	--		
	----TransformFlipper.processIKKeys obj_A times_A obj_B times_B
	--
	--
	--
	--
	--	if rig_controllers.count == 2 then
	--	(
	--		
	--		obj_A = rig_controllers[1]
	--		obj_B = rig_controllers[2]
	--		
	--		--TransformFlipper.mirrorTrasformsAtTimes obj_A objs_keys[obj_A.name] obj_B objs_keys[obj_B.name]
	--		
	--		
	--	)
	--		
	--		
	--		format "classOf rig_controllers: %\n" ( classOf rig_controllers )
	--		format "rig_controllers: %\n" rig_controllers
	--		format "rig_controllers.count: %\n" rig_controllers.count
	--		
	--		
	--		--if matchPattern ctrl_name pattern:("FK*") then
	--		--	this.swapLocalTransforms rig_controllers[1] rig_controllers[2]
	--		--
	--		--else if matchPattern ctrl_name pattern:("IK*") then
	--		--	this.flipIKControllers rig_controllers[1] rig_controllers[2]
	--		
	--	)


	private
	
	
	/**
	 */
	on create do
	(
		--format "\n"; print "LHrigWrapper.onCreate()"
	)
)
