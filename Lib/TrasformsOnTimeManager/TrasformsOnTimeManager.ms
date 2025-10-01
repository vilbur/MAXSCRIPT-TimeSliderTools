/** Trasforms on time manager
 */
struct TrasformsOnTimeManager_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	
	/** Mirror sifted phases
	  
		GET TRANSFROMS ON KEY TIMES OF BOTH OBJECTS
		FLIP ORINATATION OF TRANSFROMS
		SAVE FLIPPED TRANSFROMS TO SHIFTED KEYS ON OTHER SIDE OBJECT	  
		
		@param dictionary rig_controls list of controls E.G.: rig_controls["boy_Setup_Ctrl_IKFoot"]["L|R"] = #()
		
		
	 */
	function mirrorPhases rig_controls phase =
	(
		format "\n"; print "TrasformsOnTimeManager_v.mirrorPhases()"
		
		--interval 0
		--phase = [ currentTime.frame as integer , currentTime.frame + 2 ]
		
		KeyFrameManager = KeyFrameManager_v time:phase

		all_ctrls = #()
		
		increment = ( phase.end - phase.start ) + 1
		format "INCREMENT: %\n" increment
		
		for control_name in rig_controls.keys do
		(
			/* GET OBJECTS */ 
			obj_left  = this.getObject control_name "L"
			obj_right = this.getObject control_name "R"
			
			/* GET TRANSFROMS ON KEY TIMES OF BOTH OBJECTS */ 
			ControllerKeys_left  = ObjectControllerKeys_v(obj_left)
			ControllerKeys_right = ObjectControllerKeys_v(obj_right)
			
			/* GET ONLY KEYS IN PHASE */ 
			keys_transfroms_left  = ControllerKeys_left.getKeys  #TRANSFORMS phase
			keys_transfroms_right = ControllerKeys_right.getKeys #TRANSFORMS phase
			--format "keys_transfroms_left: %\n" keys_transfroms_left
			--format "keys_transfroms_right: %\n" keys_transfroms_right

			/* FLIP ORINATATION OF TRANSFROMS */
			
			/* SAVE FLIPPED TRANSFROMS TO SHIFTED KEYS ON OTHER SIDE OBJECT */ 
			
			if ( keys_transfroms_left.keys + keys_transfroms_right.keys ).count > 0 then
			(
				for key_time = phase.start to phase.end do
				(
					shifted_key = key_time + increment
					
					--ControllerKeys_left.keys[shifted_key]  = flipTransforms obj_left obj_right
				
					
					
				)
			
			)
			--format "ControllerKeys_left.keys: %\n" ControllerKeys_left.keys_transforms
			--KeyFrameManager.copyKeys objs:(rig_controller) transforms:true
		)
	),
	
	private
	
	
	
	
	/** Get object
	 */
	function getObject full_basename side =
	(
		--format "\n"; print "TrasformsOnTimeManager_v.getObject()"
		objs_by_name = execute ("$'"+ full_basename + "_" + side + "_*'") 
		
		objs_by_name[1] --return
	),
	
	/**
	 */
	on create do
	(
		--format "\n"; print "TrasformsOnTimeManager.onCreate()"
	)
)
