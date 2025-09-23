filein( getFilenamePath(getSourceFileName()) + "/ControllerKeys/ControllerKeys.ms" )	--"./ControllerKeys/ControllerKeys.ms"

/** Object controller keys
 */
struct ObjectControllerKeys_v
(
	/* construct */
	obj,
	
	/* required */
	
	/* keys_mods */
	keys_transforms	= Dictionary #( #POSITION, undefined ) #( #ROTATION, undefined ) #( #SCALE, undefined ),
	
	keys_mods = #(),
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Serach for keys in controllers
	 */
	function serachForKeysInControllers =
	(
		--format "\n"; print "ObjectControllerKeys_v.serachForKeysInControllers()"
		this._setTransformKeys()
		
		this.setKeytsOfModsProperties()
	),

	private

	/** Set transform keys
	 */
	function _setTransformKeys =
	(
		--format "\n"; print "ObjectControllerKeys_v._setTransformKeys()"
		
		for transform_track in keys_transforms.keys do 
		(
			--format "transform_track: %\n" transform_track
			controller = case transform_track of
			(
				#POSITION: obj.position.controller 
				#ROTATION: obj.rotation.controller 
				#SCALE:    obj.scale.controller 
			)
			
			keys_transforms[transform_track] = ControllerKeys_v(controller) keys:(this._searchForControllerKeys controller)
		)
	),
	
	/** Set mods keys_mods
	 */
	function setKeytsOfModsProperties =
	(
		--format "\n"; print "ObjectControllerKeys_v.setKeytsOfModsProperties()"
		
		mods_all = obj[4] --  Modified_Object
		
		mods = for m = 1 to mods_all.numSubs where (_mod = getSubAnim mods_all m) != undefined collect _mod

		/*  */
		for m = 1 to mods.count do
			if ( keys = this._getKeysFromMod mods[m]).keys.count > 0 then
				keys_mods[m] = keys
	),
	
	/** Remove keys from mod
	 */
	function _getKeysFromMod _mod =
	(
		--format "\n\n*********************************\n"
		--format "\n"; print "KeyFrameManager_v._getKeysFromMod()"
		--format "_mod: %\n" _mod
		
		
		/** Delete keys from keys_mods
		 */
		function _getKeysFromProperties sub_anim &mod_keys =
		(
			--format "\n\n\n"; print "KeyFrameManager_v._getKeysFromProperties()"
			--format "PROP_NAMES: %\n" ( getPropNames sub_anim )
			/* FOR EACH PROPERTY OF MOD */ 
			for i = 1 to ( prop_names = getPropNames sub_anim ).count \
				/* IF PROPERTY HAS CONTROLLER */ 
				where (ctrl = getPropertyController sub_anim prop_names[i]) != undefined do
				(
					prop_name = prop_names[i]
					/* GET KEYS FROM CONTROLLER */ 
					keys = this._searchForControllerKeys ctrl
					
					if keys.count > 0 then
						mod_keys[prop_name] = ControllerKeys_v ctrl keys
					
				)
				
			mod_keys --return
		)
		
		
		mod_keys	= Dictionary #NAME -- KEY:#prop_name VALUE:ControllerKey_v
		
		/*------------------------------------------------------------------------------
			GET KEYS OF PROPERTIES
		--------------------------------------------------------------------------------*/
		_getKeysFromProperties (_mod)(mod_keys)
		
		/*------------------------------------------------------------------------------
			GET KEYS OF CUSTOM ATTRIBUTES
		--------------------------------------------------------------------------------*/
		try( -- prevent error with deleted scene node
			
			for cust_attributes in _mod.custAttributes do
				_getKeysFromProperties (cust_attributes)(mod_keys)
			
		)catch()
		
		--format "MOD_KEYS: %\n" mod_keys
		mod_keys --return
	),
	
	/** Delete keys from controller
	 */
	function _searchForControllerKeys ctrl =
	(
		--format "\n"; print "KeyFrameManager_v._searchForControllerKeys()"
		--format "ctrl: %\n" ctrl

		keys = #()
		
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
						keys = this._searchForControllerKeys sub_ctrl
		)
		
		/*------------------------------------------------------------------------------
			GET KEYS FROM CONTROLLER
		--------------------------------------------------------------------------------*/
		else
			keys = this._getKeysFromController ctrl num_keys
		
		
		keys --return
	),
	
	/** Get keys from controller
	 */
	function _getKeysFromController ctrl num_keys =
	(
		--format "\n"; print "ObjectControllerKeys_v._getKeysFromController()"
		for k = 1 to num_keys collect (getKeyTime ctrl k).frame as integer
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ObjectControllerKeys.onCreate()"
		this.serachForKeysInControllers()
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct keys_mods necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
