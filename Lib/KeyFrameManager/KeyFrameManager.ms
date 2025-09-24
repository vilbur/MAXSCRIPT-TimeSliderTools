

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
	--phase_length,

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
		
		this.processTransforms #DELETE


		--
		----format "\nPROPERTY KEYS:\n"
		----for i = 1 to ObjectControllerKeys.keys_mods.count
		----	where ( keys_mod = ObjectControllerKeys.keys_mods[i]) != undefined  do 
		----		for prop_name in keys_mod.keys do
		----			format "%: %\n" prop_name keys_mod[prop_name]
		----		
		--	
		--	/* GET CONTROLELRS AND KEYS */ 
		--	--this._setControllersForObject(obj) --(transforms)(mods)
		--	--
		--	--/* DELETE KEYS */ 
		--	----for i = ControllersKeys.count to 1 by -1 do
		--	--for ControllerKeys in ControllersKeys do
		--	--(
		--	--	--format "ControllerKeys.keys: %\n" ControllerKeys.keys
		--	--	/* DELETE KEYS BY INDEX IN REVERSE */ 
		--	--	for k = ControllerKeys.keys.count to 1 by -1 where ( key_time = ControllerKeys.keys[k] ) != undefined do
		--	--		deleteKey ControllerKeys.ctrl k
		--	--)
		--)
	),
	
	/** Copy keys
	 */
	function copyKeys objs: transforms: mods: time: =
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		format "\n"; print "KeyFrameManager_v.copyKeys()"

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
	

	private
	
	/** Process transforms
	 */
	function processTransforms callback =
	(
		--format "\n"; print "KeyFrameManager_v.processTransforms()"
		for obj in this.objs do
		(
			ObjectControllerKeys = ObjectControllerKeys_v(obj)
		
			if this.transforms then
			(
				for transform_name in ObjectControllerKeys.keys_transforms.keys do
				(
					format "transform_name: %\n" transform_name
					ControllerKeys = ObjectControllerKeys.keys_transforms[transform_name]

					ctrl = ControllerKeys.ctrl
					
					keys = for key_time in ControllerKeys.keys collect if this.isKeyMatchTime key_time then key_time
					
					for key_index = keys.count to 1 by -1 where ( key_time = keys[key_index] ) != undefined do
					(
						case callback of
						(
							#DELETE: deleteKey ctrl key_index

							#COPY:   this._copyKey ctrl key_time
						)
						
					)
				)
			)
		
		--format "\nPROPERTY KEYS:\n"
		--for i = 1 to ObjectControllerKeys.keys_mods.count
		--	where ( keys_mod = ObjectControllerKeys.keys_mods[i]) != undefined  do 
		--		for prop_name in keys_mod.keys do
		--			format "%: %\n" prop_name keys_mod[prop_name]
		--		
			
			/* GET CONTROLELRS AND KEYS */ 
			--this._setControllersForObject(obj) --(transforms)(mods)
			--
			--/* DELETE KEYS */ 
			----for i = ControllersKeys.count to 1 by -1 do
			--for ControllerKeys in ControllersKeys do
			--(
			--	--format "ControllerKeys.keys: %\n" ControllerKeys.keys
			--	/* DELETE KEYS BY INDEX IN REVERSE */ 
			--	for k = ControllerKeys.keys.count to 1 by -1 where ( key_time = ControllerKeys.keys[k] ) != undefined do
			--		deleteKey ControllerKeys.ctrl k
			--)
		)
		
	),
	
	/** Copy key
	 */
	function _copyKey ctrl key_time =
	(
		format "\n"; print "KeyFrameManager_v._copyKey()"
		
		phase_length = time[2] - time[1] + 1
		--format "phase_length: %\n" phase_length
		new_time = ( key_time + phase_length ) as integer
		
		format "_copyKey % -> %\n" key_time new_time
		
		/* COPY KEY */ 
		with animate on at time new_time
			ctrl.value = at time key_time ctrl.value
		
		--
		--if matchPattern ( ctrl as string ) pattern:("*Position*") then
		--	appendIfUnique new_keys new_time
		--
			--if findItem new_keys new_time == 0 then
				--new_keys[key_index] = new_time

	),
	--/** Delete keys
	-- */
	--function _deleteKey =
	--(
	--	--format "\n"; print "KeyFrameManager_v._deleteKey()"
	--	
	--	
	--),
	
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
		this.objs = if objs == unsupplied then selection as Array else objs
		
		if time != unsupplied then 
			this.time = time
		
		
		/* SET TRANSFORMS NAD MODS TO TRUE if both are undefined */ 
		if not ( transforms == unsupplied and mods == unsupplied ) then
		(
			if transforms != unsupplied then 
				this.transforms = transforms
		
			if time != unsupplied then 
				this.time = time
		)
		else
			this.transforms = this.mods = true

			
		/* PHASE LENGTH */ 	
		--if phase_length != unsupplied then  
			--this.phase_length = phase_length
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
