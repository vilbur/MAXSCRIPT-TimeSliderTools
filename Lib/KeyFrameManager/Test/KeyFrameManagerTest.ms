clearListener(); print("Cleared in:\n"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../KeyFrameManager.ms" )	--"./../KeyFrameManager.ms"

/** Create test object
 */
function createTestObject =
(
	--format "\n"; print ".createTestObject()"
	
	delete objects
	
	obj = Teapot isSelected:true radius:20
	
	
    animate on
    (
        --at time 1 obj.position  = [ 10, 0, 0 ]
        at time 10 obj.position = [ 100, 0, 0 ]
        at time 20 obj.position = [ 200, 0, 0 ]
        at time 30 obj.position = [ 300, 0, 0 ]
		
		
		at time 90 Rotate obj ( AngleAxis -180 [0,0,1])

		at time 100  obj.radius = 100
    )
	

	addModifier obj ( Bend())
	
	 /* Animate Angle parameter */ 
	animate on
	(
		at time 0 obj.modifiers[#bend].angle = 0
		at time 20 obj.modifiers[#bend].angle = 45
		at time 40 obj.modifiers[#bend].angle = -30 
	)
	
	
	obj --return
)



	--obj	= selection[1]

	obj = createTestObject()


sliderTime = 10

/*------------------------------------------------------------------------------
	NEW ISNTANCE
--------------------------------------------------------------------------------*/

KeyFrameManager 	= KeyFrameManager_v() --time:#RIGHT -- DELETE CURRENT TIME IF time == undefined 


/*------------------------------------------------------------------------------
	OPTIONS
--------------------------------------------------------------------------------*/

/* DELETE ONLY SELECTED KEYS */ 
--KeyFrameManager.only_selected = true

--KeyFrameManager.time = #RIGHT
--KeyFrameManager.time = #CURRENT

/*------------------------------------------------------------------------------
	DELETE KEYS
--------------------------------------------------------------------------------*/




/* TRANSFROM AND PROPERTIES OF SELECTION */ 
--KeyFrameManager.removeKeys()

/* DELETE ALL KEYS FROM OBJECTS */ 
--KeyFrameManager.removeKeys objs: selection[1]

	
/* TRANSFORMS all */
--KeyFrameManager.removeKeys transforms:true time:undefined

/* TRANSFORMS each */
--KeyFrameManager.removeKeys transforms:#POSITION
--KeyFrameManager.removeKeys transforms:#ROTATION
--KeyFrameManager.removeKeys transforms:#SCALE



/* PROPERTIES all modifiers and baseobject */
--KeyFrameManager.removeKeys mods:true


/* MODIFIERS */
--KeyFrameManager.removeKeys mods:#MODIFIERS
 
/* BASEOBJECT */
KeyFrameManager.removeKeys mods:#BASEOBJECT


