filein( getFilenamePath(getSourceFileName()) + "/../LHrigWrapper/LHrigWrapper.ms" )	--"./../LHrigWrapper/LHrigWrapper.ms"

filein( getFilenamePath(getSourceFileName()) + "/../ObjectControllerKeys/ControllerKeys/ControllerKeys.ms" )	--"./../ObjectControllerKeys/ControllerKeys/ControllerKeys.ms"

filein( getFilenamePath(getSourceFileName()) + "/../ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./../ObjectControllerKeys/ObjectControllerKeys.ms"
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

	current_time,
	
	only_selected = false,
	
	transform_tracks_all = #( #POSITION, #ROTATION, #SCALE ),
	
	--controller_tracks = Dictionary 
	ControllersKeys	= #(),


	/* private */
	/* dependency */
	LHrigWrapper,
	
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

		this.setParameters objs:objs transforms:transforms mods:mods time:time
		
		this.processTransforms #DELETE
	),
	
	/** Copy keys
	 */
	function copyKeys objs: transforms: mods: time: =
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		--format "\n"; print "KeyFrameManager_v.copyKeys()"

		if phase_length == unsupplied then
			phase_length = if classOf this.time != Point2 then 1 else this.time.y - this.time.x + 1
		
		this.setParameters objs:objs transforms:transforms mods:mods time:time
		
		this.processTransforms #COPY
		
		
		--	/* FOR EACH CONTROLLER */ 
		--	
		--	--if LHrigWrapper.isRigController(obj.name) then
		--	--(
		--	--	LHrigWrapper.objs_keys[obj.name] = new_keys
		--	--	
		--	--	LHrigWrapper.setControllerToFlip (obj.name)
		--	--	
		--	--)
	
		
		--format "LHrigWrapper.objs_keys: %\n" LHrigWrapper.objs_keys
		--format "controllers_to_flip: %\n" LHrigWrapper.controllers_to_flip
		--
		--LHrigWrapper.mirrorControllerTransfroms()
		
	),
	
	/** Mirror keys
	 */
	function mirrorKeys objs: transforms: mods: time: =
	(
		--format "\n"; print "KeyFrameManager_v.mirrorKeys()"
		this.setParameters objs:objs transforms:transforms mods:mods time:time
		
		current_time = this.time[1]
		
		LHrigWrapper = LHrigWrapper_v key_times:( for i = this.time[1] to this.time[2] collect i as integer )
		
		/* ADD OBJECT  TO FLIPPER */ 
		for obj in this.objs do
			LHrigWrapper.addControllerToFlip (obj)
	
		/* MIRROR TRANSFORMS */ 
		LHrigWrapper.mirrorControllerTransfroms()
		
		sliderTime = current_time
	),
	

	private
	
	/** Process transforms
	 */
	function processTransforms callback =
	(
		--format "\n"; print "KeyFrameManager_v.processTransforms()"
		--format "this.transforms: %\n" this.transforms
		--format "this.mods: %\n" this.mods
		
		for obj in this.objs do
		(
			ObjectControllerKeys = ObjectControllerKeys_v(obj)
			--format "ObjectControllerKeys.keys_transforms.keys: %\n" ObjectControllerKeys.keys_transforms.keys
			
			/*------------------------------------------------------------------------------
				TRANSFORMS KEYS
			--------------------------------------------------------------------------------*/
			if this.transforms then
				for transform_type in ObjectControllerKeys.keys_transforms.keys do
					for ControllerKeys in ObjectControllerKeys.keys_transforms[transform_type] do 
						this._processControllerKeys ControllerKeys callback
		
			/*------------------------------------------------------------------------------
				MODS KEYS
			--------------------------------------------------------------------------------*/
			--if this.mods then
				for i = 1 to ObjectControllerKeys.keys_mods.count do
				(
					ModifierPropertyKeys = ObjectControllerKeys.keys_mods[i]
					
					for prop_name in ModifierPropertyKeys.keys do
						this._processControllerKeys ModifierPropertyKeys[prop_name] callback
		
				)
		)
	),
	
	/** Process controller keys
	 */
	function _processControllerKeys ControllerKeys callback =
	(
		--format "\n"; print "KeyFrameManager_v._processControllerKeys()"
		--format "CALLBACK: %\n" callback
		/** Copy key
		 */
		function _copyKey ctrl key_time =
		(
			--format "\n"; print "KeyFrameManager_v._copyKey()"
			
			phase_length = this._getPhaseLenght()
			--format "phase_length: %\n" phase_length
			new_time = ( key_time + phase_length ) as integer
			
			--format "_copyKey % -> %\n" key_time new_time
			
			/* COPY KEY */ 
			with animate on at time new_time
				ctrl.value = at time key_time ctrl.value
		)
		
		
		ctrl = ControllerKeys.ctrl
		--format "ctrl: %\n" ctrl
		
		--keys = for key_time in ControllerKeys.keys collect if this.isKeyMatchTime key_time then key_time
		keys = for key_time in ControllerKeys.keys where this.isKeyMatchTime key_time collect key_time
		
		--format "keys: %\n" keys
		--for key_index = keys.count to 1 by -1 where ( key_time = keys[key_index] ) != undefined do
		for i = keys.count to 1 by -1 do 
			--format "key_index: %\n" (getKeyIndex ctrl keys[i])
		
		for i = keys.count to 1 by -1 where ( key_index = getKeyIndex ctrl keys[i] ) > 0 do
		(
			--format "ctrl: %\n" ctrl
			--format "key_index: %\n" key_index
			case callback of
			(
				#DELETE: deleteKey ctrl key_index

				#COPY:   _copyKey ctrl key_time
				
				--#MIRROR:   _mirrorKey ctrl key_time
			)
			
		)
	),
	
	/** Get phase lenght
	 */
	function _getPhaseLenght =
	(
		--format "\n"; print "KeyFrameManager_v._getPhaseLenght()"
		
		(time[2] - time[1] + 1) as integer --return
	),
	
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
		
	),
		
	/** Set parameters
	 */
	function setParameters objs: transforms: mods: time: =
	(
		--format "\n"; print "KeyFrameManager_v.setParameters()"
		--format "time: %\n" time
		
		/* OBJECTS */ 
		this.objs = if objs == unsupplied then selection as Array else objs
		
		/* TIME */ 
		if time != unsupplied then 
			this.time = time
		
		/* TRANSFORMS AND MODS */ 
		if not ( transforms == unsupplied and mods == unsupplied ) then
		(
			/* TRANSFORMS */ 
			if transforms != unsupplied then 
				this.transforms = transforms
		
			/* MODS */ 
			if mods != unsupplied then 
				this.mods = mods
		)
		else /* SET TRANSFORMS AND MODS TO TRUE if both are undefined */ 
			this.transforms = this.mods = true
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
