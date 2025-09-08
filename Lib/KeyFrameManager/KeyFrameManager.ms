/** Key frame manager
 */
struct KeyFrameManager_v
(
	/* construct */
	time, -- #LEFT | #RIGHT | #CURRENT | undefined 
	
	/* required */
	/* properties */
	
	only_selected = false,
	
	transform_tracks_all = #( #POSITION, #ROTATION, #SCALE ),
	
	--controller_tracks = Dictionary 
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	
	/** Remove anim keys from selection
	  * 
	  * @param Array objs if undefined then use current selection
	  * 
	  * @param boolean|name|Array transforms	true|false|#POSITION|#ROTATION|#SCALE|#( #POSITION, #ROTATION, #SCALE )
	  * @param boolean|name|Array mods	true|false|#MODIFIERS|#BASEOBJECT|#( #MODIFIERS, #BASEOBJECT )
	 */
	function removeKeys objs: transforms: mods: time: =
	(
		format "\n"; print "KeyFrameManager_v.removeKeys()"
		--format "objs: %\n" objs
		
		if time != unsupplied then 
			this.time = time
		
		if objs == unsupplied then 
			objs = selection as Array
		
		if transforms == unsupplied and mods == unsupplied  then
			transforms = mods = true 
	
		--mods_all = #( #MODIFIERS, #BASEOBJECT )

		
		for obj in objs do
		(
			
			/* DELETE TRANSFORMS */ 
			for transform_track in ( this._getTransformTracks transforms ) do
				this.removeKeysFromTransformations obj transform_track
			
			/* DELETE MODS */ 
			if isProperty obj #numSubs and obj.numSubs > 0 then
			(
				mods_all = obj[4] --  Modified_Object
				
				mods_to_delete = case mods of
				(
					true:         this._getMods mods_all mods_all.numSubs
					
					#MODIFIERS:   this._getMods mods_all (mods_all.numSubs - 1)
					
					#BASEOBJECT: #( getSubAnim mods_all mods_all.numSubs )
			
					default: #()
				)
				
				
				for _mod in mods_to_delete do
					this._deleteKeysFromMod _mod
			)
		)
	),
	
	/** Get transform tracks
	 */
	function _getTransformTracks transforms =
	(
		--format "\n"; print "KeyFrameManager_v._getTransformTracks()"
		if classOf transforms == Array then
				transforms
			
			else  if classOf transforms == name then
				#(transforms)
				
			
			else if transforms == true then
				transform_tracks_all
			
			else #()
		
	),
	
	/** Get mods
	 */
	function _getMods mods max_index =
	(
		--format "\n"; print "KeyFrameManager_v._getMods()"
		for m = 1 to max_index where (_mod = getSubAnim mods m) != undefined collect _mod
	),
	

	--/** Remove keys
	-- */
	--function removeAllAnimKeys obj =
	--(
	--	--format "\n"; print "KeyFrameManager_v.removeAllAnimKeys()"
	--	--format "\n"
	--	--format "\nremoveAllKeys OBJ: % TRIM: %: " obj.name ( if time != undefined then time else false )
	--	this.removeKeysFromTransformations( obj )
	--	
	--	this.removeKeysOfProperties( obj )
	--),

	function removeKeysFromTransformations obj transform_track =
	(
		format "\n"; print "KeyFrameManager_v.removeKeysFromTransformations()"
		format "transform_track: %\n" transform_track

		--track_list = Dictionary #( #position, obj.position.controller ) #( #position, obj.rotation.controller ) #( #position, obj.scale.controller)

		ctrl = this.getTransformController obj transform_track
		format "ctrl: %\n" ctrl
		--for ctrl in track_list do
			--if isController ctrl then
		this._deleteKeysFromController ctrl
				
	),
	
	/** Get transform track
	 */
	function getTransformController obj transform_track =
	(
		--format "\n"; print "KeyFrameManager_v.getTransformController()"
		case transform_track of
			(
				#POSITION: obj.position.controller 
				#ROTATION: obj.rotation.controller 
				#SCALE:    obj.scale.controller 
			)
	),
	
	/** Remove keys from mod
	 */
	function _deleteKeysFromMod _mod =
	(
		format "\n"; print "KeyFrameManager_v._deleteKeysFromMod()"
		/*------------------------------------------------------------------------------

			DELETE KEYS OF PROPERTIES
			
		--------------------------------------------------------------------------------*/
		this._deleteKeysFromProperties (_mod)
		
		/*------------------------------------------------------------------------------
		  
			DELETE KEYS OF CUSTOM ATTRIBUTES
			
		--------------------------------------------------------------------------------*/
		try( -- prevent error with deleted scene node
			
			for cust_attributes in _mod.custAttributes do
				this._deleteKeysFromProperties (cust_attributes)
			
		)catch()
		
	),

	private
	
	/** Delete keys from properties
	 */
	function _deleteKeysFromProperties sub_anim =
	(
		--format "\n"; print "KeyFrameManager_v._deleteKeysFromProperties()"
					
		for i = 1 to ( prop_names = getPropNames sub_anim ).count do 
		(
			ctrl = getPropertyController sub_anim prop_names[i]
			
			if ctrl != undefined then
				this._deleteKeysFromController ctrl
		)
	),

	/** Delete keys from controller
	 */
	function _deleteKeysFromController ctrl =
	(
		format "\n"; print "KeyFrameManager_v._deleteKeysFromController()"
		--format "\n\n*********************************\n"
		--format "ctrl: %\n" ctrl
		format "isController ctrl: %\n" (isController ctrl)
		format "classOf ctrl: %\n" ( classOf ctrl )
		format "NUMKEYS CTRL: %\n" (numKeys CTRL)
		--format "ctrl.numSubs: %\n" ctrl.numSubs
		
		/*------------------------------------------------------------------------------
			SEARCH FOR KEYS IN SUBANIMS
		--------------------------------------------------------------------------------*/
		if ( num_keys = numKeys ctrl ) == -1 then
		(
			/* LOOP SUBANIMS */ 
			for i = 1 to ctrl.numSubs do
				/* GET SUBANIM */ 
				if (sub_anim_ctrl = getSubAnim ctrl i) != undefined then
					/* GET CONTROLLER OF SUBANIM */ 
					if (sub_ctrl = getPropertyController ctrl sub_anim_ctrl.name) != undefined then
						/* DELETE KEYS OF SUBANIM */ 
						this._deleteKeysFromController sub_ctrl
		)
		
		/*------------------------------------------------------------------------------
			DELETE KEYS FROM CONTROLLER
		--------------------------------------------------------------------------------*/
		else
			this._deleteKeys ctrl num_keys
		
	),
	

	/** Delete keys
	 */
	function _deleteKeys ctrl num_keys =
	(
		format "\n"; print "KeyFrameManager_v._deleteKeys()"
		format "time: %\n" time
		--format "currentTime: %\n" currentTime

		keys_to_delete	= #()

		/* GET KEYS */ 
		for k = 1 to num_keys do
		(
			key_time = getKeyTime ctrl k
			
			format "key: % key_time: %\n" k key_time
			
			key_match_time = case time of
			(
				#LEFT:  key_time < currentTime
				#RIGHT: key_time > currentTime
				
				#CURRENT: key_time == currentTime
				
				default: true
			)
			
			format "KEYS_TO_DELETE: %\n" keys_to_delete
			if key_match_time then
				if not only_selected or ( only_selected and isKeySelected ctrl k ) then
					appendIfUnique keys_to_delete k
			
		)

		/* DELETE KEYS */ 
		for i = keys_to_delete.count to 1 by -1 do 
			deleteKey ctrl keys_to_delete[i]
	
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
