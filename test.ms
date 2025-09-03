clearListener(); print("Cleared in:\n"+getSourceFileName())



/*
  Function to delete animation keys to the right of current frame on selection
*/
function trimKeysRightFromCurrentFrame includeCurrentFrame =
(
	current_time = currentTime
	
	start_time = if includeCurrentFrame then current_time else (current_time + 1)
	format "start_time: %\n" start_time
	
	-- helper to safely delete keys from any controller
	function deleteKeysAfterTime ctrl start_time =
	(
		format "\n\n*********************************\n"
		format "ctrl: %\n" ctrl
		format "isController ctrl: %\n" (isController ctrl)
		format "classOf ctrl: %\n" ( classOf ctrl )
		format "NUMKEYS CTRL: %\n" (numKeys CTRL)
		format "ctrl.numSubs: %\n" ctrl.numSubs
		
		
		
		--num_keys = numKeys ctrl

		--for i = 1 to ctrl.numSubs where ( num_keys = numKeys ctrl ) > 0 do
		
		--if ( num_keys = numKeys ctrl ) >0 then
		for i = 1 to ctrl.numSubs do
		(
			controler_keys	= #()
		
			sub_anim_ctrl = getSubAnim ctrl i
			
			format "sub_anim_ctrl: %\n" sub_anim_ctrl
			subCtrl = getPropertyController ctrl sub_anim_ctrl.name
			format "subCtrl: %\n" subCtrl

			--num_keys = numKeys subCtrl
			--format "num_keys: %\n" num_keys

			if subCtrl != undefined then
			(
				format "NUMKEYS subCtrl: %\n" (numKeys subCtrl)
				
				
				for k = 1 to numKeys subCtrl do
				(
					
					key_time = getKeyTime subCtrl k
					format "key_time: %\n" key_time
					is_key_deleted = case of
					(
						
						--(xxxxxxxxxxxxxxx):
						default: key_time >= start_time
					)
					
					if is_key_deleted then
						appendIfUnique controler_keys k
				)
			)
				
			
			format "controler_keys: %\n" controler_keys
		
			--for i = controler_keys.count to 1 by -1 do 
				--deleteKey subCtrl controler_keys[i]
			
			
		)
		
		

	)
	
	
	function deleteKeysFromController ctrl start_time =
	(
		format "\n\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@n"
		format "ctrl: %\n" ctrl
		format "isController ctrl: %\n" (isController ctrl)
		format "classOf ctrl: %\n" ( classOf ctrl )
		format "NUMKEYS CTRL: %\n" (numKeys CTRL)
		format "ctrl.numSubs: %\n" ctrl.numSubs

		controler_keys	= #()
		 num_keys = numKeys ctrl
		--for i = 1 to ctrl.numSubs where ( num_keys = numKeys ctrl ) > 0 do
		(
		
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
			
		)
			
		
		format "controler_keys: %\n" controler_keys
		
		
		for i = controler_keys.count to 1 by -1 do 
		--for controler_key in controler_keys do
			deleteKey ctrl controler_keys[i]

	)
	for obj in selection where isValidNode obj do
	(
		-- transform controllers: position, rotation, scale
		track_list = #(obj.position.controller, obj.rotation.controller, obj.scale.controller)

		for ctrl in track_list do
		(
			if isController ctrl then
			(
				format "\n---------------------------------------------\n"
				format "ctrl: %\n" ctrl
				format "isController ctrl: %\n" (isController ctrl)
	
				deleteKeysAfterTime ctrl start_time
				--deleteKeysFromController ctrl start_time
			)
		)

		format "\n================================================\n"
		 ----optional: other animatable subAnims (modifiers, custom attributes)
		
		if 1==0 then
		if isProperty obj #numSubs and obj.numSubs > 0 then
		(
				--format "sub_anim %: %\n" i (getSubAnim obj i)
			
			--for i = 1 to obj.numSubs do
			/* LOOP MODFIERS */ 
			for i = 1 to obj.numSubs where matchPattern ( obj[i] as string ) pattern:("*Modified_Object") do
			(
				sub_anim = getSubAnim obj i
				format "\n\n"
				--format "% isController : %\n" sub_anim (isController sub_anim)
				--format "showProperties sub_anim: %\n" ( showProperties sub_anim )
				--format "sub_anim: %\n" ( matchPattern (sub_anim as string ) pattern:("*Modified_Object"))
				--format "sub_anim.numSubs: %\n" sub_anim.numSubs
				

				/* LOOP EACH MOD IN MODIFIER STACK, but not baseobject ( -1 ) */ 
				for j = 1 to sub_anim.numSubs - 1 do
				(
					format "\n"
					sub_anim_mod = getSubAnim sub_anim j
					format "MODIFIER: %\n" sub_anim_mod.name
					--format "showProperties sub_anim_mod: %\n" (showProperties sub_anim_mod)
					format "custAttributes sub_anim_mod: %\n" (sub_anim_mod.custAttributes )
					format "sub_anim_mod: %\n" sub_anim_mod

					
					for p = 1 to ( prop_names = getPropNames sub_anim_mod).count do 
					(
						format "PROP_NAME: %\n" prop_names[p]
						
						subCtrl = getPropertyController sub_anim_mod prop_names[p]
						--format "subCtrl: %\n" subCtrl
						
						if subCtrl != undefined then
							deleteKeysFromController subCtrl start_time
					)

					for cust_attributes in sub_anim_mod.custAttributes do
					(
						format "CUST_ATTRIBUTE: %\n" cust_attributes
						format "showProperties cust_attributes: %\n" ( showProperties cust_attributes )
						prop_names = getPropNames cust_attributes
						format "PROP_NAMES: %\n" prop_names
						for p = 1 to ( prop_names = getPropNames cust_attributes).count do 
						(
							
							format "\n"
							format "PROP_NAME: %\n" prop_names[p]
							
							subCtrl = getPropertyController cust_attributes prop_names[p]
							format "subCtrl: %\n" subCtrl
							
							if subCtrl != undefined then
								deleteKeysFromController subCtrl start_time
						)
						
					)
				)
			)
		)
	)
) -- return

trimKeysRightFromCurrentFrame false   -- delete keys at and after current frame
-- trimKeysRightFromCurrentFrame false  -- delete only future keys
