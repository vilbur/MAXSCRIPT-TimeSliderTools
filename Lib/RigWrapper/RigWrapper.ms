filein( getFilenamePath(getSourceFileName()) + "/../TransformFlipper/TransformFlipper.ms" )	--"./../TransformFlipper/TransformFlipper.ms"
filein( getFilenamePath(getSourceFileName()) + "/LeftRightControls/LeftRightControls.ms" )	--"./LeftRightControls/LeftRightControls.ms"
/**
 */
struct RigWrapper_v
(
	/* construct */
	key_times, -- #( int ) -- times to flip

	/* required */
	

	/* properties */
	control_mane_pattern = "(.*_Setup_Ctrl_([^_]+_)).*",
	--objs_keys	= Dictionary #STRING, -- KEY:obj.name VALUE:#(key frames to procerss)
	rig_controls,
	--objs = Dictionary #STRING,
	--objs = Dictionary #STRING,
	objs = #(),
	
	rx = ( dotNetClass "System.Text.RegularExpressions.RegEx" ),
	
	TransformFlipper = TransformFlipper_v(),

	/** Load rig
	 */
	function loadRig master_control =
	(
		--format "\n"; print "RigWrapper_v.loadRig()"

		
		processed_objects = #()

		
		rig_controls	= Dictionary #STRING -- KEY: VALUE:
		
		rig_name = (filterString master_control.name "_")[1]	
		
		rig_objs = execute ("$'"+ rig_name +"_Setup_Ctrl_*'") as Array
		
		for rig_obj in rig_objs where findItem processed_objects rig_obj == 0 do
		(
			/* ANALIZE OBJ NAME */ 
			split_name = this.splitName rig_obj.name
			basename   = split_name[2]
			side       = split_name[3]
			
			
			/* GET OBJ NMAE PATTERN */ 
			full_basename = rig_name +"_Setup_Ctrl_"+basename -- E.G.: "boy_Setup_Ctrl_IKFoot"

			
			/* GET OBJECTS WITH SAME PATTERN OF NAME  */ 
			same_name_objs = execute ("$'"+ full_basename +"_*'") as Array
			
			
			/* ADD CONTROL PAIR TO DICTIONARY */ 
			if same_name_objs.count == 2 and (side == "L" or side == "R") then
				rig_controls[full_basename] = (LeftRightControls_v()).addObjects(same_name_objs)(full_basename)

			
			/* AVOID PROCESSING OF SAME OBJECTS AGAIN  */ 
			processed_objects += same_name_objs
		)
		
		
		--format "rig_objs.count: %\n" rig_objs.count
		--format "rig_controls: %\n" rig_controls


		rig_controls --return
	),
	
	/** Mirror sifted phases
	  
		GET TRANSFROMS ON KEY TIMES OF BOTH OBJECTS
		FLIP ORINATATION OF TRANSFROMS
		SAVE FLIPPED TRANSFROMS TO SHIFTED KEYS ON OTHER SIDE OBJECT	  
		
		@param dictionary rig_controls list of controls E.G.: rig_controls["boy_Setup_Ctrl_IKFoot"]["L|R"] = #()
		
		
	 */
	function mirrorPhases phase =
	(
		format "\n"; print "PhaseCreator_v.mirrorPhases()"
		
		--interval 0
		--phase = [ currentTime.frame as integer , currentTime.frame + 2 ]
		
		KeyFrameManager = KeyFrameManager_v time:phase

		all_ctrls = #()
		
		format "INCREMENT: %\n" increment
		
		for control_name in rig_controls.keys do 
		(
		--	TransformFlipper 	= TransformFlipper_v()
			--format "\n"
			LeftRightControls = rig_controls[control_name]
			
			
			LeftRightControls.switchKeysOnTimes phase
			

		--	--format "ControllerKeys_left.keys: %\n" ControllerKeys_left.keys_transforms
		--	--KeyFrameManager.copyKeys objs:(rig_controller) transforms:true
		)
	),


	/** Split name
	 */
	function splitName obj_name part: =
	(
		--format "\n"; print "RigWrapper_v.splitName()"
		matches = rx.matches obj_name "(.*)_Setup_Ctrl_([^_]+)_([^_]+).*" -- ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase 

		/* RESULT: #(#("boy_Setup_Ctrl_IKFoot_R_O_1LRV", "IKFoot", "L")) */ 
		result	= ( for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value ))[1] --return
		--format "result: %\n" result
		deleteItem result 1
		
		case part of
		(
			#RIG:  result[1] 
			#NAME: result[2] 
			#SIDE: result[3]
			
			default: result
		)
	),
	
	/* STRUCT */
	--mapped function getAllChildren _node &children = ( join children _node.children;	if _node.children.count > 0 then this.getAllChildren _node.children &children ),
	

	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Is rig controller
	 */
	function isRigController obj_name =
	(
		--format "\n"; print "RigWrapper_v.isRigController()"
		--format "isRigController: %\n" (matchPattern obj_name pattern:("*_Setup_Ctrl_*"))
		matchPattern obj_name pattern:("*_Setup_Ctrl_*")
	),
	
	/** Set controller to flip
	 */
	function addControllerToFlip obj =
	(
		--format "\n================================================\n"
		--format "\n"; print "RigWrapper_v.addControllerToFlip()"
		--format "obj.name: %\n" obj.name
		
		if this.isRigController(obj.name) then
			append objs obj

	),
	
	/** Search for rigs in scene
	 */
	function searchForRigsInScene =
	(
		--format "\n"; print "RigWrapper_v.searchForRigsInScene()"

		execute ("$'*_Setup_Ctrl_MasterControl_G'") as Array --return
	),
	/** Search for rigs in scene
	 */
	function getNamesOfRigsInScene =
	(
		--format "\n"; print "RigWrapper_v.searchForRigsInScene()"
		
		rig_masters = execute ("$'*_Setup_Ctrl_MasterControl_G'") as Array
		
		
		rig_names = for rig_master in rig_masters collect (filterString rig_master.name "_")[1]
		
		--format "rig_masters: %\n" rig_masters
		
		--#( "Boy" ) --return
		rig_names --return
	),
	/** Get control object
	  
		@param string rig_name E.G.: "boy"
		@param string ctrl_name E.G.: "IKFoot"
	  
	   @return array of objects E.G.: #( $boy_Setup_Ctrl_IKFoot_R_O_1LRV, $boy_Setup_Ctrl_IKFoot_L_O_1LLV)
	   
	 */
	function getControlObject rig_name ctrl_name =
	(
		--format "\n"; print "RigWrapper_v.getControlObject()"
		execute ("$'"+rig_name+"_Setup_Ctrl_"+ctrl_name+"*'") as Array
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
		--format "\n\n"; print "RigWrapper_v.mirrorControllerTransfroms()"
		--format "KEY_TIMES: %\n" key_times
		--format "this.objs: %\n" this.objs
		--format "this.objs.count: %\n" this.objs.count

		
		for i = this.objs.count to 1 by -1 where ( obj = objs[i] ) != undefined do 
		(
			--format "\n------------------------------------------------------------\n\n"
			--format "obj: %\n" obj
			
			ObjectControllerKeys = ObjectControllerKeys_v(obj)
			
			rig_controllers = this._getObjectsWithSamePatternOfName(obj.name)
			
		--	fk_or_ik = if matchPattern result[1][3] pattern:("IK*") then #IK else #FK

			
			if rig_controllers.count == 2 then
			(
				--index_first	= findItem rig_controllers obj
				
				pair_obj = rig_controllers[ if findItem rig_controllers obj == 1 then 2 else 1 ]
				
				index_pair  = findItem objs pair_obj
				
				--format "index_pair: %\n" index_pair
				--format "pair_obj: %\n" pair_obj
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
		--format "\n"; print "RigWrapper_v._getObjectsWithSamePatternOfName()"
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
		--format "\n"; print "RigWrapper.onCreate()"
	)
)
