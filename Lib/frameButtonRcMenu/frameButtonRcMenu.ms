/** Frame button rc menu
 */
function frameButtonRcMenu frame =
(
	/** Get int string
	 */
	function getIntString num = (num as integer )  as string

	transform_tracks = #( "POSITION", "ROTATION", "SCALE" ) 
	format "\n"; print ".frameButtonRcMenu()"
	--format "DIALOG_time_slider_tools.DL_phase.selection: %\n" DIALOG_time_slider_tools.DL_phase.selection
	phase_length = DIALOG_time_slider_tools.DL_phase.items[DIALOG_time_slider_tools.DL_phase.selection] as integer
	
	phase_range = [ currentTime, currentTime + phase_length - 1 ] 
	format "PAHSE_RANGE: %\n" phase_range
	time_delete = if keyboard.controlPressed then "#RIGHT" else "#CURRENT"
	KeyFrameManager_side   = "(KeyFrameManager_v( if keyboard.controlPressed then \"#LEFT\" else \"#RIGHT\"))"

	/*------------------------------------------------------------------------------
		COMMANDS
	--------------------------------------------------------------------------------*/
	removeKeys_cmd = "(KeyFrameManager_v( "+time_delete+" )).removeKeys "
	copyKeys_cmd   = "(KeyFrameManager_v( "+phase_range as string +" )).copyKeys "
	mirrorKeys_cmd   = "(KeyFrameManager_v( "+phase_range as string +" )).mirrorKeys "

	/*------------------------------------------------------------------------------
		HELPERS
	--------------------------------------------------------------------------------*/
	copy_keys_label = " KEYS " + getIntString (phase_range.x) + " - " + getIntString (phase_range.y)  + " TO: " + getIntString (phase_range.y + 1) + " - " + getIntString (phase_range.y + phase_length+ 1 )
	
	/*------------------------------------------------------------------------------
		MENU
	--------------------------------------------------------------------------------*/
	Menu = RcMenu_v name:"MenuName"
	
	Menu.item	"REMOVE CURRENT KEY"	"(KeyFrameManager_v( #CURRENT )).removeKeys()"
	
	Menu.separator()
	
	
	
	
	/*------------------------------------------------------------------------------
		TRIM
	--------------------------------------------------------------------------------*/
	Menu.item	"TRIM keys to • Ctrl: Trim LEFT"	(KeyFrameManager_side+".removeKeys()")
	
	menu_trim = Menu.menu ("TRIM • Ctrl: Trim LEFT") --flat:false
	
	menu_trim.item "TRIM ALL TRANSFORMS" ( KeyFrameManager_side + "transforms:true" )
	
	for transform_track in transform_tracks do
		menu_trim.item ("Trim " + transform_track ) ( KeyFrameManager_side+".removeKeys TRANSFORMS:" + transform_track)

		menu_trim.separator()
		
		menu_trim.item ("Trim Properties" ) ( KeyFrameManager_side+".removeKeys()")
	
	Menu.separator()
	
	
	
	/*------------------------------------------------------------------------------
		DELETE TRANSFORMS
	--------------------------------------------------------------------------------*/
	
	
	del_menu = Menu.menu "Delete TRANSFORMS"

	/* TRANSFORMS all */
	del_menu.item "Delete ALL TRANSFORMS" ( removeKeys_cmd + "transforms:true" )
	
	
	/* TRANSFORMS each */
	for transform_track in transform_tracks do 
		del_menu.item ("Delete "+transform_track) ( removeKeys_cmd + "transforms:#" + transform_track )
	
	
	
	/*------------------------------------------------------------------------------
		DELETE PROPERTIES
	--------------------------------------------------------------------------------*/

	/* PROPERTIES all */
	Menu.item "Delete ALL PROPERTIES" ( removeKeys_cmd + "properties:true" )
	
	
	
	--del_menu.separator()
	--
	--/* PROPERTIES all modifiers and baseobject */
	--del_menu.item "REMOVE ALL MODIFIERS & BASEOBJECT KEYS" "KeyFrameManager.removeKeys properties:true"
	--
	--/* MODIFIERS */
	--del_menu.item "REMOVE MODIFIERS KEYS" "KeyFrameManager.removeKeys properties:#MODIFIERS"
	--
	--/* BASEOBJECT */
	--del_menu.item "REMOVE BASEOBJECT KEYS" "KeyFrameManager.removeKeys properties:#BASEOBJECT"
	--
	--Menu.addItem del_menu+ " - " + getIntString (phase_range.y)
	
	Menu.separator()
	
	Menu.item ( "COPY" + copy_keys_label ) ( copyKeys_cmd + " transforms:true" )
	
	Menu.separator()
	
	Menu.item ( "MIRROR" + copy_keys_label ) ( mirrorKeys_cmd + " transforms:true" )

	--Menu.separator()
	
	--submenu = Menu.menu "COPY KEYS"

	/* SUBMENU TRANSFORMS */
--format "PHASE_LENGTH: %\n" phase_length
	--KeyFrameManager 	= KeyFrameManager_v() --time:#RIGHT -- DELETE CURRENT TIME IF time == undefined 
	
	/* Copy keys in range 1-10 to 11-20 */ 
	--KeyFrameManager.copyKeys time:[ 1, 10 ] transforms:true mods:false -- default increment is length ofrange + 1
	
	/* COPY POSITION KEYS ABOUT 30 FRAMES FORWARD */ 
	--KeyFrameManager.copyKeys time:[ 0, 10 ] increment:30 transforms:#POSITION
	

	
	popUpMenu (Menu.create())
	
	
)
