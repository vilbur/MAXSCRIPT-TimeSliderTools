/** Frame button rc menu
 */
function frameButtonRcMenu frame =
(
	format "\n"; print ".frameButtonRcMenu()"
	time_key = if keyboard.controlPressed then "#RIGHT" else "#CURRENT"

	Menu = RcMenu_v name:"MenuName"
	
	Menu.item	"REMOVE CURRENT KEY"	"(KeyFrameManager_v( #CURRENT )).removeKeys()"
	
	Menu.separator()
	
	Menu.item	"TRIM KEYS TO RIGHT"	"(KeyFrameManager_v( #RIGHT )).removeKeys()"
	
	Menu.separator()
	
	/* SUBMENU TRANSFORMS */
	submenu = Menu.menu "TRANSFORMS"

	removeKeys_cmd = "(KeyFrameManager_v( "+time_key+" )).removeKeys "
	
	/* TRANSFORMS all */
	submenu.item	"DELETE ALL TRANSFORMS CTRL: Trim Right"	( removeKeys_cmd + "transforms:true" )
	
	/* TRANSFORMS each */
	submenu.item "POSITION" ( removeKeys_cmd + "transforms:#POSITION" )
	submenu.item "ROTATION" ( removeKeys_cmd + "transforms:#ROTATION" )
	submenu.item "SCALE"    ( removeKeys_cmd + "transforms:#SCALE" )
	
	--submenu.separator()
	--
	--/* PROPERTIES all modifiers and baseobject */
	--submenu.item "REMOVE ALL MODIFIERS & BASEOBJECT KEYS" "KeyFrameManager.removeKeys mods:true"
	--
	--/* MODIFIERS */
	--submenu.item "REMOVE MODIFIERS KEYS" "KeyFrameManager.removeKeys mods:#MODIFIERS"
	--
	--/* BASEOBJECT */
	--submenu.item "REMOVE BASEOBJECT KEYS" "KeyFrameManager.removeKeys mods:#BASEOBJECT"
	--
	--Menu.addItem submenu

	
	
	popUpMenu (Menu.create())
	
	
)
