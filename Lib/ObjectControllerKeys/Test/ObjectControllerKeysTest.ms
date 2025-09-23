clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ObjectControllerKeys.ms" )	--"./../ObjectControllerKeys.ms"




/** Create test object
 */
function createTestObject times =
(
	delete objects

	--obj = Box pos:pos wirecolor:( color (random 0 255) (random 0 255) (random 0 255))
	obj = Teapot()	--pos:pos --wirecolor:wirecolor
	
	addModifier obj ( Bend() )
	
	animate on
	(
		for i = 1 to times.count do
		(
			_time = times[i]
			
			val = _time * 10
			
			at time _time
			(
				
				obj.position.y += val
	
				obj.rotation.z += val
				
				obj.modifiers[#bend].angle = val
			)
		)
	)
	
	
	animationRange = Interval 0 (amax times)
	
	obj --return
)

obj = createTestObject #( 0, 1 ,3 , 5 )  


/*  */ 
ObjectControllerKeys = ObjectControllerKeys_v(obj)

format "\nRESULT OF TEST:\n"

format "ObjectControllerKeys.tramsforms: %\n" ObjectControllerKeys.tramsforms
format "ObjectControllerKeys.properties: %\n" ObjectControllerKeys.properties

--ObjectControllerKeys.mirrorTrasformsAtTimes obj_A times_A obj_B times_B
--ObjectControllerKeys.mirrorTrasformsAtTimes obj_A times_all obj_B times_all

--ObjectControllerKeys.mirrorTrasformsAtTimes selection[1] times_A selection[2] times_8
--ObjectControllerKeys.mirrorTrasformsAtTimes selection[1] times_all selection[2] times_all

