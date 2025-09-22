filein( getFilenamePath(getSourceFileName()) + "/ControllerKeys/ControllerKeys.ms" )	--"./ControllerKeys/ControllerKeys.ms"

/** Key frame manager
 */
struct KeyFrameManager_v
(
	/* construct */
	time, -- undefined | #LEFT | #RIGHT | #CURRENT | [ range_start, range_end ]
	
	/* required */
	/* properties */
	objs,
	transforms,
	mods,

	only_selected = false,
	
	transform_tracks_all = #( #POSITION, #ROTATION, #SCALE ),
	
	--controller_tracks = Dictionary 
	ControllersKeys	= #(),


	/* private */
	/* dependency */
	LHrigWrapper = LHrigWrapper_v(),
	
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
		--format "\n"; print "KeyFrameManager_v.removeKeys()"
		--format "objs: %\n" objs
		this.setParameters objs:objs transforms:transforms mods:mods time:time
		
		
		for obj in this.objs do
		(
			/* GET CONTROLELRS AND KEYS */ 
			this._setControllersForObject(obj) --(transforms)(mods)
			
			/* DELETE KEYS */ 
			--for i = ControllersKeys.count to 1 by -1 do
			for ControllerKeys in ControllersKeys do
			(
				--format "ControllerKeys.keys: %\n" ControllerKeys.keys
				/* DELETE KEYS BY INDEX IN REVERSE */ 
				for k = ControllerKeys.keys.count to 1 by -1 where ( key_time = ControllerKeys.keys[k] ) != undefined do
					deleteKey ControllerKeys.ctrl k
			)
		)
	),
	
	/** Copy keys
	 */
	function copyKeys objs: transforms: mods: time: increment: =
	(
		format "\n"; print "KeyFrameManager_v.copyKeys()"
		
		this.setParameters objs:objs transforms:transforms mods:mods time:time

		if increment == unsupplied then
			increment = if classOf this.time != Point2 then 1 else this.time.y - this.time.x + 1
		
		
		for obj in this.objs do
		(
			/* GET CONTROLELRS AND KEYS */ 
			this._setControllersForObject(obj) --(transforms)(mods)
			
			new_keys = #()
		
			/* FOR EACH CONTROLLER */ 
			for ControllerKeys in ControllersKeys do
			(
				--format "ControllerKeys.keys: %\n" ControllerKeys.keys
				/* DELETE KEYS BY INDEX IN REVERSE */ 
				for key_index = ControllerKeys.keys.count to 1 by -1 where ( key_time = ControllerKeys.keys[key_index] ) != undefined do
				(
					format "ControllerKeys.ctr: %\n" ControllerKeys.ctrl
					
					new_time = ( key_time + increment ) as integer
					format "new_time: %\n" new_time
					
					/* COPY KEY */ 
					with animate on at time new_time
						ControllerKeys.ctrl.value = at time key_time ControllerKeys.ctrl.value
					
					
					if matchPattern ( ControllerKeys.ctrl as string ) pattern:("*Position*") then
						appendIfUnique new_keys new_time
					
					--if findItem new_keys new_time == 0 then
					--	new_keys[key_index] = new_time
					
				)
			)
			
			--if LHrigWrapper.isRigController(obj.name) then
			--(
			--	LHrigWrapper.objs_keys[obj.name] = new_keys
			--	
			--	LHrigWrapper.setControllerToFlip (obj.name)
			--	
			--)
			--	
			format "%: NEW_KEYS: %\n" obj.name new_keys
			
		)
		
		--format "LHrigWrapper.objs_keys: %\n" LHrigWrapper.objs_keys
		--format "controllers_to_flip: %\n" LHrigWrapper.controllers_to_flip
		--
		--LHrigWrapper.mirrorControllerTransfroms()
		
	),
	

	private
	
	/** Set parameters
	 */
	function setParameters objs: transforms: mods: time: =
	(
		--format "\n"; print "KeyFrameManager_v.setParameters()"
		if time != unsupplied then 
			this.time = time
		
		
		this.objs = if objs == unsupplied then selection as Array else objs
		
		if not ( transforms == unsupplied and mods == unsupplied ) then
		(
			if transforms != unsupplied then 
				this.transforms = transforms
		
			if time != unsupplied then 
				this.time = time
		)
		else
			this.transforms = this.mods = true
	),
	
	

	/** Set controllers for object
	 */
	function _setControllersForObject obj =
	(
		--format "\n"; print "KeyFrameManager_v._setControllersForObject()"
		--format "TRANSFORMS: %\n" transforms
		--format "MODS:       %\n" mods
		
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
		
		/*
		*/ 
		function _getKeysFromTransformations obj transform_track =
		(
			--format "\n"; print "KeyFrameManager_v._getKeysFromTransformations()"
	
			ctrl =  case transform_track of
					(
						#POSITION: obj.position.controller 
						#ROTATION: obj.rotation.controller 
						#SCALE:    obj.scale.controller 
					)
					
			this._searchForControllerKeys ctrl
		)
		
		this.ControllersKeys	= #()
		
		/* TRANSFORMS */ 
		for transform_track in ( _getTransformTracks transforms ) do
			_getKeysFromTransformations obj transform_track
		
		
		
		
		/* DELETE MODS */
		if mods == true then
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
	

	
	/** Remove keys from mod
	 */
	function _getKeysFromMod _mod =
	(
		--format "\n"; print "KeyFrameManager_v._getKeysFromMod()"
		/** Delete keys from properties
		 */
		function _getKeysFromProperties sub_anim =
		(
			--format "\n"; print "KeyFrameManager_v._getKeysFromProperties()"
						
			for i = 1 to ( prop_names = getPropNames sub_anim ).count do 
			(
				ctrl = getPropertyController sub_anim prop_names[i]
				
				if ctrl != undefined then
					this._searchForControllerKeys ctrl
			)
		)

		/*------------------------------------------------------------------------------

			GET KEYS OF PROPERTIES
			
		--------------------------------------------------------------------------------*/
		_getKeysFromProperties (_mod)
		
		/*------------------------------------------------------------------------------
		  
			GET KEYS OF CUSTOM ATTRIBUTES
			
		--------------------------------------------------------------------------------*/
		try( -- prevent error with deleted scene node
			
			for cust_attributes in _mod.custAttributes do
				_getKeysFromProperties (cust_attributes)
			
		)catch()
		
	),


	/** Delete keys from controller
	 */
	function _searchForControllerKeys ctrl =
	(
		--format "\n"; print "KeyFrameManager_v._searchForControllerKeys()"
		--format "\n\n*********************************\n"
		--format "ctrl: %\n" ctrl
		--format "isController ctrl: %\n" (isController ctrl)
		--format "classOf ctrl: %\n" ( classOf ctrl )
		--format "NUMKEYS CTRL: %\n" (numKeys CTRL)
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
						this._searchForControllerKeys sub_ctrl
		)
		
		/*------------------------------------------------------------------------------
			GET KEYS FROM CONTROLLER
		--------------------------------------------------------------------------------*/
		else
			this._getKeys ctrl num_keys
		
	),
	

	
	/** GET KEYS OF CONTROLLER
	  * 
	  * fill this.ControllersKeys
	 */
	function _getKeys ctrl num_keys =
	(
		--format "\n"; print "KeyFrameManager_v._getKeys()"
		--format "time: %\n" time
		
		/** Is key match time
		 */
		function isKeyMatchTime key_time =
		(
			--format "\n"; print "KeyFrameManager_v.isKeyMatchTime()"
			/*------------------------------------------------------------------------------
				BY CURRENT TIME
			--------------------------------------------------------------------------------*/
			if classOf this.time != Point2 then
				case this.time of
				(
					#LEFT:  key_time < currentTime
					#RIGHT: key_time > currentTime
					
					#CURRENT: key_time == currentTime
					
					default: true -- all keys
				)
			else
			/*------------------------------------------------------------------------------
				IS KEY IN TIME RANGE
			--------------------------------------------------------------------------------*/
				key_time >= time.x and key_time <= time.y
			
		)
		
		
		--format "currentTime: %\n" currentTime
		ControllerKeys = ControllerKeys_v(ctrl)

		/*------------------------------------------------------------------------------
			FOR EACH KEY OF CONTROLLER
		--------------------------------------------------------------------------------*/
		for k = 1 to num_keys do
			/* GET KEY IF MATCH TIME */ 
			if isKeyMatchTime(getKeyTime ctrl k) then
				/* IF KEY IS SELECTED OR NOT */ 
				if not only_selected or ( only_selected and isKeySelected ctrl k ) then
					ControllerKeys.keys[k] = (getKeyTime ctrl k).frame as integer

		
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
