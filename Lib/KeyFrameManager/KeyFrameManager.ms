filein( getFilenamePath(getSourceFileName()) + "/ControllerKeys/ControllerKeys.ms" )	--"./ControllerKeys/ControllerKeys.ms"

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
	ControllersKeys	= #(),


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
			/* GET CONTROLELRS AND KEYS */ 
			this._setControllersForObject(obj)(transforms)(mods)
			
			/* DELETE KEYS */ 
			--for i = ControllersKeys.count to 1 by -1 do
			for ControllerKeys in ControllersKeys do
				/* DELETE KEYS BY INDEX IN REVERSE */ 
				for k = ControllerKeys.keys.count to 1 by -1 do 
					deleteKey ControllerKeys.ctrl ControllerKeys.keys[k]
		)
	),
	
	
	/** Set controllers for object
	 */
	function _setControllersForObject obj transforms mods =
	(
		--format "\n"; print "KeyFrameManager_v._setControllersForObject()"
		/** Get mods
		 */
		function _getMods mods max_index = for m = 1 to max_index where (_mod = getSubAnim mods m) != undefined collect _mod
		
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
			
		)
		
		ControllersKeys	= #()
		
		/* DELETE TRANSFORMS */ 
		for transform_track in ( _getTransformTracks transforms ) do
			this._getKeysFromTransformations obj transform_track
		
		
		/* DELETE MODS */ 
		if isProperty obj #numSubs and obj.numSubs > 0 then
		(
			mods_all = obj[4] --  Modified_Object
			
			mods_to_delete = case mods of 
			(
				true:         _getMods mods_all mods_all.numSubs
				
				#MODIFIERS:   _getMods mods_all (mods_all.numSubs - 1)
				
				#BASEOBJECT: #( getSubAnim mods_all mods_all.numSubs )
		
				default: #()
			)
			
			/*  */ 	
			for _mod in mods_to_delete do
				this._getKeysFromMod _mod
		)
	),
	
	function _getKeysFromTransformations obj transform_track =
	(
		format "\n"; print "KeyFrameManager_v._getKeysFromTransformations()"

		ctrl =  case transform_track of
				(
					#POSITION: obj.position.controller 
					#ROTATION: obj.rotation.controller 
					#SCALE:    obj.scale.controller 
				)
				
		this._searchForController ctrl
	),
	
	/** Remove keys from mod
	 */
	function _getKeysFromMod _mod =
	(
		format "\n"; print "KeyFrameManager_v._getKeysFromMod()"
		/** Delete keys from properties
		 */
		function _getKeysFromProperties sub_anim =
		(
			--format "\n"; print "KeyFrameManager_v._getKeysFromProperties()"
						
			for i = 1 to ( prop_names = getPropNames sub_anim ).count do 
			(
				ctrl = getPropertyController sub_anim prop_names[i]
				
				if ctrl != undefined then
					this._searchForController ctrl
			)
		)

		/*------------------------------------------------------------------------------

			DELETE KEYS OF PROPERTIES
			
		--------------------------------------------------------------------------------*/
		_getKeysFromProperties (_mod)
		
		/*------------------------------------------------------------------------------
		  
			DELETE KEYS OF CUSTOM ATTRIBUTES
			
		--------------------------------------------------------------------------------*/
		try( -- prevent error with deleted scene node
			
			for cust_attributes in _mod.custAttributes do
				_getKeysFromProperties (cust_attributes)
			
		)catch()
		
	),

	private
	
	--/** Delete keys from properties
	-- */
	--function _getKeysFromProperties sub_anim =
	--(
	--	--format "\n"; print "KeyFrameManager_v._getKeysFromProperties()"
	--				
	--	for i = 1 to ( prop_names = getPropNames sub_anim ).count do 
	--	(
	--		ctrl = getPropertyController sub_anim prop_names[i]
	--		
	--		if ctrl != undefined then
	--			this._searchForController ctrl
	--	)
	--),

	/** Delete keys from controller
	 */
	function _searchForController ctrl =
	(
		format "\n"; print "KeyFrameManager_v._searchForController()"
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
						this._searchForController sub_ctrl
		)
		
		/*------------------------------------------------------------------------------
			DELETE KEYS FROM CONTROLLER
		--------------------------------------------------------------------------------*/
		else
			this._getKeys ctrl num_keys
		
	),
	

	/** Delete keys
	 */
	function _getKeys ctrl num_keys =
	(
		format "\n"; print "KeyFrameManager_v._getKeys()"
		format "time: %\n" time
		--format "currentTime: %\n" currentTime
		ControllerKeys = ControllerKeys_v(ctrl)

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
			
			/* GET KEY IF MATCH TIME */ 
			if key_match_time then
				if not only_selected or ( only_selected and isKeySelected ctrl k ) then
					appendIfUnique ControllerKeys.keys k
				
		)

		if ControllerKeys.keys.count > 0 then
			append ControllersKeys ControllerKeys
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
