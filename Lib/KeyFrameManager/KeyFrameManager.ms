/** Key frame manager
 */
struct KeyFrameManager_v
(
	/* construct */
	obj,

	/* required */
	

	/* properties */
	include_current_frame = false,
	
	start_time = if include_current_frame then currentTime else ( currentTime + 1),


	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	/** Remove keys
	 */
	function removeKeys =
	(
		--format "\n"; print "KeyFrameManager_v.removeKeys()"
		track_list = #(obj.position.controller, obj.rotation.controller, obj.scale.controller)

		for ctrl in track_list do
		(
			if isController ctrl then
			(
				format "\n---------------------------------------------\n"
				format "ctrl: %\n" ctrl
				format "isController ctrl: %\n" (isController ctrl)
	
				this.deleteKeysFromController ctrl start_time
				--deleteKeysFromController ctrl start_time
			)
		)
		
		
	),
		

	private

	/** Delete keys from controller
	 */
	function deleteKeysFromController ctrl start_time =
	(
		--format "\n"; print "KeyFrameManager_v.deleteKeysFromController()"
		format "\n\n*********************************\n"
		format "ctrl: %\n" ctrl
		format "isController ctrl: %\n" (isController ctrl)
		format "classOf ctrl: %\n" ( classOf ctrl )
		format "NUMKEYS CTRL: %\n" (numKeys CTRL)
		format "ctrl.numSubs: %\n" ctrl.numSubs
		
		if ( num_keys = numKeys ctrl ) == -1 then
		(
			for i = 1 to ctrl.numSubs where (sub_anim_ctrl = getSubAnim ctrl i) != undefined do
			(
				
				format "sub_anim_ctrl: %\n" sub_anim_ctrl
				
				subCtrl = getPropertyController ctrl sub_anim_ctrl.name
				
				format "subCtrl: %\n" subCtrl
	
	
				if subCtrl != undefined then
					this.deleteKeysFromController subCtrl num_keys

				
			)
		)
		else
			this._deleteKeys ctrl num_keys
		
	),
	
	/** Delete keys
	 */
	function _deleteKeys ctrl num_keys =
	(
		--format "\n"; print "KeyFrameManager_v._deleteKeys()"
		controler_keys	= #()

		for k = 1 to num_keys do
		(
			
			key_time = getKeyTime ctrl k
			
			format "key_time: %\n" key_time
			is_key_deleted = case of
			(
				
				--(xxxxxxxxxxxxxxx):
				default: key_time >= start_time
			)
			
			if is_key_deleted then
				appendIfUnique controler_keys k
		)
		
		for i = controler_keys.count to 1 by -1 do 
			deleteKey ctrl controler_keys[i]
	
	),
	

	/**
	 */
	on create do
	(
		--format "\n"; print "KeyFrameManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
