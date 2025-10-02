/** Trasforms on time manager
 */
struct PhaseCreator_v
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
		format "\n"; print "PhaseCreator_v.mirrorPhases()"
		
		--interval 0
		--phase = [ currentTime.frame as integer , currentTime.frame + 2 ]
		
		KeyFrameManager = KeyFrameManager_v time:phase

		all_ctrls = #()
		
		increment = ( phase.end - phase.start ) + 1
		format "INCREMENT: %\n" increment
		
		for control_name in rig_controls.keys do 
		(
			TransformFlipper 	= TransformFlipper_v()
			
			/* GET OBJECTS */ 
			obj_left  = this.getObject control_name "L"
			obj_right = this.getObject control_name "R"
			
			/* GET TRANSFROMS ON KEY TIMES OF BOTH OBJECTS */ 
			ControllerKeys_left  = ObjectControllerKeys_v(obj_left)
			ControllerKeys_right = ObjectControllerKeys_v(obj_right)
			
			/* GET ONLY KEYS IN PHASE */ 
			keys_transfroms_left  = ControllerKeys_left.getKeys  #TRANSFORMS phase
			keys_transfroms_right = ControllerKeys_right.getKeys #TRANSFORMS phase

			/* FLIP ORINATATION OF TRANSFROMS */
			
			/* SAVE FLIPPED TRANSFROMS TO SHIFTED KEYS ON OTHER SIDE OBJECT */ 
			
			if ( keys_transfroms_left + keys_transfroms_right ).count > 0 then
			(
				
				
				
				for key_time = phase.start.frame as integer to phase.end.frame as integer do
				(
					format "key_time: %\n" key_time
					key_time_shifted = key_time + increment
					
					/* IF SOURCE KEY EXISTS ON TIME */ 
					if findItem keys_transfroms_left key_time then
					(
						rig_controls[control_name]["L"][key_time] = obj_left.transform
						
						
					)
					
					
					--ControllerKeys_left.keys[key_time_shifted]  = flipTransforms obj_left obj_right
					
					
				)
				--format "rig_controls[control_name]: %\n" rig_controls[control_name]
				for side in rig_controls[control_name].keys do
					--format "side: %\n" side
					format "% % %\n" control_name side rig_controls[control_name][side]
				
				
			
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
		--format "\n"; print "PhaseCreator_v.getObject()"
		objs_by_name = execute ("$'"+ full_basename + "_" + side + "_*'") 
		
		objs_by_name[1] --return
	),
	
	/**
	 */
	on create do
	(
		--format "\n"; print "PhaseCreator.onCreate()"
	)
)
