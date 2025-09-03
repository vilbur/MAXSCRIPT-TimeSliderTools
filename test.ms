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
		format "ctrl[1]: %\n" ctrl[1]
		--
		controler_keys	= #()
		
		for i = 1 to ctrl.numSubs where ( num_keys = numKeys ctrl ) > 0 do
		
		
			for k = 1 to num_keys do
			(
				key_time = getKeyTime ctrl k
				
				is_key_deleted = case of
				(
					
					--(xxxxxxxxxxxxxxx):
					default: key_time >= start_time
				)
				
				if is_key_deleted then
					appendIfUnique controler_keys k
			)
			
			
		
		format "controler_keys: %\n" controler_keys
		
		
		
		for controler_key in controler_keys do
			deleteKey ctrl controler_key

	)
	function deleteKeysAfterTimeMODIFIER ctrl start_time =
	(
		format "\n\n*********************************\n"
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
		
		
		
		for controler_key in controler_keys do
			deleteKey ctrl controler_key

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
	
				--deleteKeysAfterTime ctrl start_time
			)
		)

		format "\n================================================\n"
		 ----optional: other animatable subAnims (modifiers, custom attributes)
		 
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
				
				
				----(
				--	if isProperty sub_anim #sub_anim and sub_anim.numSubs > 0 then
				--	(
						/* LOOP EACH MOD IN MODIFIER STACK, but not baseobject ( -1 ) */ 
						for j = 1 to sub_anim.numSubs - 1 do
						(
							format "\n"
							sub_anim_mod = getSubAnim sub_anim j
							format "MODIFIER: %\n" sub_anim_mod.name
							--format "showProperties sub_anim_mod: %\n" (showProperties sub_anim_mod)
							
							--format "sub_anim_mod: %\n" sub_anim_mod
							--format "classOf sub_anim_mod: %\n" ( classOf sub_anim_mod )
							
							
							--for  prop_name in getPropNames sub_anim_mod do
							for p = 1 to ( prop_names = getPropNames sub_anim_mod).count do 
							(
								--format "prop_names[p]: %\n" prop_names[p]
								
								subCtrl = getPropertyController sub_anim_mod prop_names[p]
								--format "subCtrl: %\n" subCtrl
								
								if subCtrl != undefined then
									deleteKeysAfterTimeMODIFIER subCtrl start_time

								          --prop_val = getProperty sub_anim_mod prop_name
										--format "% : %\n" prop_names prop_val
							)

						)
							
--							
--							for k = 1 to sub_anim_mod.numSubs do
--							(
--								sub_anim_mod_sub = sub_anim_mod[k]
--								
--								--format "\n"
--								--format "sub_anim_mod_sub: %\n" sub_anim_mod_sub.name
--								--format "showProperties sub_anim_mod_sub: %\n" ( showProperties sub_anim_mod_sub )
--								--
--
--
--								
--								for l = 1 to sub_anim_mod_sub.numSubs do
--								(
--									sub_anim_mod_sub_sub = sub_anim_mod_sub[l]
--									--format "sub_anim_mod_sub_sub: %\n" sub_anim_mod_sub_sub
--
--								--subCtrl = getPropertyController sub_anim_mod_sub_sub sub_anim_mod_sub_sub.name
--								--format "subCtrl: %\n" subCtrl
--									
--									--format "\n"
----									
--									--format "sub_anim_mod_sub_sub: %\n" sub_anim_mod_sub_sub
--									----format "classOf sub_anim_mod_sub_sub: %\n" ( classOf sub_anim_mod_sub_sub )
--									--format "sub_anim_mod_sub_sub.numSubs: %\n" sub_anim_mod_sub_sub.numSubs
--									
--									for m = 1 to sub_anim_mod_sub_sub.numSubs do
--									(
--									--	format "isController sub_anim_mod_sub_sub[m]: %\n" (isController sub_anim_mod_sub_sub[m])
--									--	--format "classOf sub_anim_mod_sub_sub[m]: %\n" ( classOf sub_anim_mod_sub_sub[m] )
--										--format "sub_anim_mod_sub_sub[m]: %\n" sub_anim_mod_sub_sub[m]
--										--format "sub_anim_mod_sub_sub[m].numSubs: %\n" sub_anim_mod_sub_sub[m].numSubs
--
--										--subCtrl = getPropertyController sub_anim_mod_sub_sub[m] sub_anim_mod_sub_sub[m].name
--										--format "subCtrl: %\n" subCtrl
----
--									--		for n= 1 to sub_anim_mod_sub_sub[m].numSubs do
--									--	format "isController sub_anim_mod_sub_sub[n]: %\n" (isController sub_anim_mod_sub_sub[n])
--									--		--format "sub_anim_mod_sub_sub[n]: %\n" sub_anim_mod_sub_sub[n]
--									--
--									--	
--									)
--									
--								)
--								
--							)
				--format "showProperties sub_anim_mod: %\n" ( showProperties sub_anim_mod )

								--format "classOf sub_anim_mod[k]: %\n" ( classOf sub_anim_mod[k] )
								--format "sub_anim_mod[k]: %\n" sub_anim_mod[k]

							
							
							
							--deleteKeysAfterTime sub_anim_mod start_time
				--	)
				--	else
				--	(
				--		deleteKeysAfterTime sub_anim start_time
				--	)
				--)
			)
		)
	)
) -- return

trimKeysRightFromCurrentFrame false   -- delete keys at and after current frame
-- trimKeysRightFromCurrentFrame false  -- delete only future keys
