/** Left right controls
 */
struct LeftRightControls_v
(
	/* construct */
	/* required */
	
	/* properties */
	--obj_left,
	--obj_right,
	
	left,
	right,
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Add objects
	 */
	function addObjects objs full_basename =
	(
		--format "\n"; print "LeftRightControls_v.addObjects()"
 
		for obj in objs do
			for side in #( "L", "R" ) where matchPattern obj.name pattern:(full_basename + "_"+side+"_*") do 
				case side of
				(
					"L": this.left  = ObjectControllerKeys_v(obj)
					"R": this.right = ObjectControllerKeys_v(obj)
				)

		this --return
	),

	/** Copy keys on times
	 */
	function switchKeysOnTimes phase =
	(
		--format "\n"; print "RigWrapper_v.switchKeysOnTimes()"
		
		increment = ( phase.end - phase.start ) + 1


		/* GET ONLY KEYS IN PHASE */ 
		keys_left  =  left.getKeys #TRANSFORMS phase
		keys_right = right.getKeys #TRANSFORMS phase
	
		/* FLIP ORINATATION OF TRANSFROMS */
		
		/* SAVE FLIPPED TRANSFROMS TO SHIFTED KEYS ON OTHER SIDE OBJECT */ 
		
		this._copyKeysOnTimes left  right keys_left  increment
		
		this._copyKeysOnTimes right left  keys_right increment
		
	),
	
	private
	
	/** Copy keys on times
	 */
	function _copyKeysOnTimes source_node target_node keys increment =
	(
		format "\n"; print "LeftRightControls_v._copyKeysOnTimes()"
		
		for key_time in keys do 
		(
			format "key_time: %\n" key_time

			
			key_time_shifted = key_time + increment
			format "key_time_shifted: %\n" key_time_shifted
			
			--copyTransformAtTime source_node target_node source_time target_time

		)
	),
	
	
	/* 
	Function to copy transform data (position, rotation or both) 
	from one object at given time and apply it to another object at different time 
	*/
	function copyTransformAtTime source_node target_node source_time target_time mode:#both =
	(
		if (isValidNode source_node and isValidNode target_node) then
		(
			at time source_time
			(
				src_pos = source_node.position
				src_rot = source_node.rotation
			)
			
			at time target_time animate on
			(
				case mode of
				(
					#position: ( target_node.position = src_pos )
					#rotation: ( target_node.rotation = src_rot )
					#both: 
					(
						target_node.position = src_pos
						target_node.rotation = src_rot
					)
				)
			)
		)
		-- return
	),


	/**
	 */
	on create do
	(
		--format "\n"; print "LeftRightControls.onCreate()"
	)

)
