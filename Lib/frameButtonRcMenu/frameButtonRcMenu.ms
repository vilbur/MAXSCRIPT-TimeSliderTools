/** Frame button rc menu
 */
function frameButtonRcMenu frame =
(
	format "\n"; print ".frameButtonRcMenu()"
	--format "DIALOG_time_slider_tools.DL_phase.selection: %\n" DIALOG_time_slider_tools.DL_phase.selection
	phase_length = DIALOG_time_slider_tools.DL_phase.items[DIALOG_time_slider_tools.DL_phase.selection] as integer
	
	phase_range = [ currentTime, currentTime + phase_length - 1 ] 
	format "PAHSE_RANGE: %\n" phase_range
	time_delete = if keyboard.controlPressed then "#RIGHT" else "#CURRENT"

	Menu = RcMenu_v name:"MenuName"
	
	Menu.item	"REMOVE CURRENT KEY"	"(KeyFrameManager_v( #CURRENT )).removeKeys()"
	
	Menu.separator()
	
	Menu.item	"TRIM KEYS TO RIGHT"	"(KeyFrameManager_v( #RIGHT )).removeKeys()"
	
	Menu.separator()
	
	/* SUBMENU TRANSFORMS */
	transfroms = Menu.menu "DELETE TRANSFORMS"

	removeKeys_cmd = "(KeyFrameManager_v( "+time_delete+" )).removeKeys "
	copyKeys_cmd   = "(KeyFrameManager_v( "+phase_range as string +" )).copyKeys "
	
	/* TRANSFORMS all */
	transfroms.item	"DELETE ALL TRANSFORMS CTRL: Trim Right"	( removeKeys_cmd + "transforms:true" )
	
	/* TRANSFORMS each */
	transfroms.item "POSITION" ( removeKeys_cmd + "transforms:#POSITION" )
	transfroms.item "ROTATION" ( removeKeys_cmd + "transforms:#ROTATION" )
	transfroms.item "SCALE"    ( removeKeys_cmd + "transforms:#SCALE" )
	
	--transfroms.separator()
	--
	--/* PROPERTIES all modifiers and baseobject */
	--transfroms.item "REMOVE ALL MODIFIERS & BASEOBJECT KEYS" "KeyFrameManager.removeKeys mods:true"
	--
	--/* MODIFIERS */
	--transfroms.item "REMOVE MODIFIERS KEYS" "KeyFrameManager.removeKeys mods:#MODIFIERS"
	--
	--/* BASEOBJECT */
	--transfroms.item "REMOVE BASEOBJECT KEYS" "KeyFrameManager.removeKeys mods:#BASEOBJECT"
	--
	--Menu.addItem transfroms

	
	Menu.separator()
	
	Menu.item	("COPY KEYS " + phase_range.x as string + " - " + phase_range.y as string + " TO: " + ((phase_range.y + 1) as integer )  as string )	( copyKeys_cmd + " transforms:true" )

	
	Menu.separator()
	
	submenu = Menu.menu "COPY KEYS"

	/* SUBMENU TRANSFORMS */
--format "PHASE_LENGTH: %\n" phase_length
	--KeyFrameManager 	= KeyFrameManager_v() --time:#RIGHT -- DELETE CURRENT TIME IF time == undefined 
	
	/* Copy keys in range 1-10 to 11-20 */ 
	--KeyFrameManager.copyKeys time:[ 1, 10 ] transforms:true mods:false -- default increment is length ofrange + 1
	
	/* COPY POSITION KEYS ABOUT 30 FRAMES FORWARD */ 
	--KeyFrameManager.copyKeys time:[ 0, 10 ] increment:30 transforms:#POSITION
	

	
	popUpMenu (Menu.create())
	
	
)
