/** Frame button rc menu
 */
function frameButtonRcMenu frame =
(
	format "\n"; print ".frameButtonRcMenu()"
	
	Menu = RcMenu_v name:"MenuName"
	
	Menu.item	"REMOVE CURRENT KEY from selection CTRL: only selected"	"(KeyFrameManager_v         only_selected:keyboard.controlPressed ).removeAnimKeysFromObjects()"
	
	Menu.separator()
	
	Menu.item	"TRIM KEYS TO RIGHT  CTRL: only selected"	"(KeyFrameManager_v(#RIGHT) only_selected:keyboard.controlPressed ).removeAnimKeysFromObjects()"
	
	/* DEFINE SUBMENU */
	--submenu = Menu.menu "Submenu"


	popUpMenu (Menu.create())
	
	
)
