/** Key frame manager
 */
struct KeyFrameManager_v
(
	/* construct */
	/* required */
	/* properties */
	trim, -- #LEFT | #RIGHT
	
	only_selected = false,
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	
	/** Remove anim keys from selection
	  * 
	  * @param Array objs if undefined then use current selection
	  * 
	  * 
	 */
	function removeAnimKeysFromObjects objs: =
	(
		--format "\n"; print "KeyFrameManager_v.removeAnimKeysFromObjects()"
		--format "objs: %\n" objs
		if objs == unsupplied then 
			objs = selection as Array
		
		
		for obj in objs do
			--format "obj: %\n" obj
			this.removeAllAnimKeys obj
		
	),
	
	/** Remove keys
	 */
	function removeAllAnimKeys obj =
	(
		--format "\n"; print "KeyFrameManager_v.removeAllAnimKeys()"
		--format "\n"
		--format "\nremoveAllKeys OBJ: % TRIM: %: " obj.name ( if trim != undefined then trim else false )
		this.removeKeysFromTransformations( obj )
		
		this.removeKeysOfProperties( obj )
	),

	function removeKeysFromTransformations obj =
	(
		--format "\n"; print "KeyFrameManager_v.removeAllAnimKeys()"
		track_list = #(obj.position.controller, obj.rotation.controller, obj.scale.controller)

		for ctrl in track_list do
			if isController ctrl then
				this._deleteKeysFromController ctrl
				
	),
		
	/** Remove keys of properties
	  
		SubAnim[1]:Visibility
		SubAnim[2]:Space_Warps
		SubAnim[3]:Transform
		SubAnim[4]:Modified_Object
		SubAnim[5]:Material
		SubAnim[6]:Image_Motion_Blur_Multiplier
		SubAnim[7]:Object_Motion_Blur_On_Off
		
	 */
	function removeKeysOfProperties obj =
	(
		--format "\n"; print "KeyFrameManager_v.removeKeysOfProperties()"
		
		if isProperty obj #numSubs and obj.numSubs > 0 then
		(
			mods = obj[4]
			
			/*------------------------------------------------------------------------------
				LOOP EACH MOD IN MOD STACK 
			--------------------------------------------------------------------------------*/ 
			for m = 1 to mods.numSubs where (_mod = getSubAnim mods m) != undefined do
			(
				/* PROPERTY KEYS */ 
				this._deleteKeysFromProperties (_mod)
				
				/* CUSTOM ATTRIBUTES KEYS */
				try(
					
					for cust_attributes in _mod.custAttributes do
						this._deleteKeysFromProperties (cust_attributes)
					
				)catch()
			)
		)
	),

	private
		

	/** Delete keys from controller
	 */
	function _deleteKeysFromController ctrl =
	(
		--format "\n"; print "KeyFrameManager_v._deleteKeysFromController()"
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
						this._deleteKeysFromController sub_ctrl
		)
		
		/*------------------------------------------------------------------------------
			DELETE KEYS FROM CONTROLLER
		--------------------------------------------------------------------------------*/
		else
			this._deleteKeys ctrl num_keys
		
	),
	
	
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
	
	/** Delete keys
	 */
	function _deleteKeys ctrl num_keys =
	(
		--format "\n"; print "KeyFrameManager_v._deleteKeys()"
		--format "currentTime: %\n" currentTime
		controler_keys	= #()

		/* GET KEYS */ 
		for k = 1 to num_keys do
		(
			key_time = getKeyTime ctrl k
			
			--format "key_time: %\n" key_time
			key_match_time = case trim of
			(
				#LEFT:  key_time < currentTime
				#RIGHT: key_time > currentTime
				
				default: key_time == currentTime
			)
			
			if key_match_time then
				if not only_selected or ( only_selected and isKeySelected ctrl k ) then
					appendIfUnique controler_keys k
			
		)
		
		/* DELETE KEYS */ 
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
