clearListener(); print("Cleared in:\n"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../KeyFrameManager.ms" )	--"./../KeyFrameManager.ms"

/** Create test object
 */
function createTestObject =
(
	--format "\n"; print ".createTestObject()"
	
	delete objects
	
	obj = Teapot()
	
	addModifier obj ( Bend())
	
    animate on
    (
        at time 1 obj.position  = [ 10, 0, 0 ]
        at time 10 obj.position = [ 50, 0, 0 ]
    )
	
	-- Animate Angle parameter
	animate on
	(
		at time 0 obj.modifiers[#bend].angle = 0
		at time 20 obj.modifiers[#bend].angle = 45
		at time 40 obj.modifiers[#bend].angle = -30
	)
	obj --return
)


if selection.count > 0 then
	obj	= selection[1]
else
	obj = createTestObject()


KeyFrameManager 	= KeyFrameManager_v(obj)

KeyFrameManager.removeAllKeys()