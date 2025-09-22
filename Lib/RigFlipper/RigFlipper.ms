/** Rig flipper
 */
struct RigFlipper_v
(
	/* construct */
	

	/* required */
	

	/* properties */
	controller_types = #( #POSITION, #ROTATION ),
	
	lock_flags = Dictionary #( #POSITION, #{1..3} ) #( #ROTATION, #{4..6} ),

	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** 
	 */
	function _getKeyIndex ctrl _time key_index =
	(
		--format "\n"; print "RigFlipper_v._getKeyIndex()"
		--format "ctrl: %\n" ctrl
		--format "numKeys ctrl: %\n" (numKeys ctrl)
		--format "ctrl.numSubs: %\n" ctrl.numSubs
		
		if ctrl.numSubs > 0 then
		(
			for i = 1 to ctrl.numSubs do
			(
				/* GET SUBANIM */ 
				if (sub_anim_ctrl = getSubAnim ctrl i) != undefined then
				(
					--format "sub_anim_ctrl: %\n" sub_anim_ctrl
					--format "sub_anim_ctrl.name: %\n" sub_anim_ctrl.name
					/* GET CONTROLLER OF SUBANIM */ 
					if (sub_ctrl = getPropertyController ctrl sub_anim_ctrl.name) != undefined then
					(
						--format "sub_ctrl: %\n" sub_ctrl
					 
					 
						/* DELETE KEYS OF SUBANIM */ 
						key_index = this._getKeyIndex sub_ctrl _time key_index
					)
				)
			)
		)
		
		/*------------------------------------------------------------------------------
			GET KEYS FROM CONTROLLER
		--------------------------------------------------------------------------------*/
		else
		if numKeys ctrl > 0 then
		(
			--format "KEY_INDEX: %\n" (getKeyIndex ctrl _time)
			key_index = getKeyIndex ctrl _time
		)
		
		--format "key_index: %\n" key_index
		key_index --return
	),
	
	/* 
	Process animation keys between two nodes
	*/
	function mirrorTrasformsAtTimes obj_A times_A obj_B times_B =
	(
		format "\n"; print "RigFlipper_v.mirrorTrasformsAtTimes()"

		format "obj_A: %\n" obj_A
		format "obj_B: %\n" obj_B
		--format "times_A: %\n" times_A
		--format "times_B: %\n" times_B

		lock_position_A = this.isTransformLocked obj_A #POSITION
		lock_rotation_A = this.isTransformLocked obj_A #ROTATION
		--format "lock_position_A: %\n" lock_position_A
		--format "lock_rotation_A: %\n" lock_rotation_A
		lock_position_B = this.isTransformLocked obj_B #POSITION
		lock_rotation_B = this.isTransformLocked obj_B #ROTATION

		
		all_times = sort(makeUniqueArray (times_A + times_B))
		--format "all_times: %\n" all_times
		--sort all_times
		
		for _time in all_times do
		(
			format "\n--------------------\n"
			
			format "_time: %\n" _time
			--with animate on
			--at time _time
			(
				sliderTime = _time
				
				for controller_type in controller_types do
				(
					--format "--------------------\n"
					--format "controller_type: %\n" controller_type
					
					ctrl_a = this._getController obj_A controller_type
			
					
					ctrl_b = this._getController obj_B controller_type
					
					
					--format "\n===========================================\n"
					
					key_a = 0
					key_b = 0
					
					key_a = this._getKeyIndex ctrl_a ( _time as time ) key_a
					
					--format "\n===========================================\n"
					key_b = this._getKeyIndex ctrl_b ( _time as time ) key_b
						--format "key_a: %\n" key_a
						--format "key_b: %\n" key_b
						
					if key_a != undefined and key_b != undefined then
					(
				
						hasA = key_a > 0
						hasB = key_b > 0
	
						if hasA and hasB then
						(
							
							if lock_position_A.count > 0 then
								this.swapLocalRotation obj_A obj_B _time
							else
								this.flipIKControllers obj_A obj_B _time
							

						)
						--else if hasA and not hasB then
						--(
						--	--for controller_type in #( #position, #rotation, #scale ) do
						--		this.swapLocalTransforms obj_A obj_B _time controller_type
						--)
						--else if hasB and not hasA then
						--(
						--	--for controller_type in #( #position, #rotation, #scale ) do
						--		this.swapLocalTransforms obj_B obj_A _time controller_type
						--)
						
					)
					
				)
			)
		)
	),
	
	/** Get controller
	 */
	function _getController obj type =
	(
		--format "\n"; print "RigFlipper_v._getController()"
		case type of
		(
			#POSITION: obj.position.controller
			#ROTATION: obj.rotation.controller
		)
	),
	
	/* 
	Check if controller has key on given time
	*/
	function hasKeyAtTime ctrl _time =
	(
		if ctrl != undefined then
		(
			for i = 1 to numKeys ctrl do
				if (getKeyTime ctrl i) == _time then return true
		)
		false
	),
	
	/** Is transform locked
	  *
	  *
	  * @return array of locked axises
	 */
	function isTransformLocked obj type =
	(
		--format "\n"; print "RigFlipper_v.isTransformLocked()"
		for i in ((getTransformLockFlags obj) * lock_flags[type] ) collect #( #X, #Y, #Z, #X, #Y, #Z, #X, #Y, #Z )[i]
	),
	
		
	/* 
	Swap IK goal positions of two nodes.
	Works if nodes are IK effectors (like foot controls).
	*/
	function flipIKControllers obj1 obj2 _time =
	(
		-- Store the properties of the first object
			--format "\n"; print "RigFlipper_v.flipIKControllers()"
		_time = _time as time
		with animate on
		at time currentTime
		(
		  --at time tStart obj.pos.z=loadheight+liftHeight
		  --at time tEnd obj.pos.z=loadheight

			--format "_time: %\n" _time
			tempPos = obj1.pos
			tempRot = obj1.rotation
		
			-- Apply the second object's properties to the first, inverting the X-axis for position
			obj1.pos = [-obj2.pos.x, obj2.pos.y, obj2.pos.z]
			obj1.rotation = obj2.rotation
		
			-- Apply the stored properties to the second object, inverting the X-axis for position
			obj2.pos = [-tempPos.x, tempPos.y, tempPos.z]
			obj2.rotation = tempRot
			
		)
	
	),

	
	/*
	Swap local rotation between two objects
	*/
	function swapLocalRotation objA objB _time =
	(
		--format "\n"; print "RigFlipper_v.swapLocalRotation()"
		_time = _time as time
	
		with animate on
		at time currentTime 		
		(
			 parentA = objA.parent
			 parentB = objB.parent
			
			-- compute local rotations
			 localRotA = if parentA != undefined then (inverse parentA.rotation * objA.rotation) else objA.rotation
			 localRotB = if parentB != undefined then (inverse parentB.rotation * objB.rotation) else objB.rotation
			
			-- swap them
			if parentA != undefined then
				objA.rotation = parentA.rotation * localRotB
			else
				objA.rotation = localRotB
			
			if parentB != undefined then
				objB.rotation = parentB.rotation * localRotA
			else
				objB.rotation = localRotA
		)
		-- return
	),

	
	--/* 
	--Swap local transforms of two selected nodes
	--Works for rig controllers (foot, hand, etc.)
	--*/
	--function swapLocalTransforms nodeA nodeB _time controller_type =
	--(
	--	if nodeA != undefined and nodeB != undefined then
	--	(
	--		parentA = nodeA.parent
	--		parentB = nodeB.parent
	--
	--		-- get local transforms
	--		tmA = if parentA != undefined then (nodeA.transform * inverse parentA.transform) else nodeA.transform
	--		tmB = if parentB != undefined then (nodeB.transform * inverse parentB.transform) else nodeB.transform
	--
	--		with animate on at time _time
	--		(
	--			
	--			if parentA != undefined then
	--				nodeA.transform = tmB * parentA.transform
	--			else
	--				nodeA.transform = tmB
	--	
	--				
	--			if parentB != undefined then
	--				nodeB.transform = tmA * parentB.transform
	--			else
	--				nodeB.transform = tmA
	--		)
	--	)
	--),



	private


	/**
	 */
	on create do
	(
		--format "\n"; print "RigFlipper.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
