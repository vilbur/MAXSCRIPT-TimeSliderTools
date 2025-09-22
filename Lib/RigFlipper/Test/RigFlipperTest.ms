clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../RigFlipper.ms" )	--"./../RigFlipper.ms"





/** Create test object
 */
function createTestObject pos times =
(

	obj = Box pos:pos wirecolor:( color (random 0 255) (random 0 255) (random 0 255))
	
	animate on
	(
		for t = 1 to times.count do
		(
			
			_time = times[t]
			
			at time _time 
			case of
			(
				--( mod _time 2 == 0 ): obj.position.x += _time
				( mod t 2 == 0 ): obj.rotation = (eulerAngles 0 0 180)


				default: obj.position.y += _time as integer
				--(
				--	obj.position.x += _time
				--	obj.rotation = (eulerAngles 0 45 0 )
				--)
			)
		)
	)
	
	obj --return
)


/* Arrays of times (normally you’d collect these from controllers) */
times_A = #( 0, 10 ,30 , 40, 50 )
--times_A = #( 20 )

times_B = #( 0, 20 ,30 ,40 )
--times_B = #( 20 )

delete objects

obj_A = createTestObject [ -50, 0, 50 ] times_A

obj_B = createTestObject [  50, 0, 0 ] times_B


times_all = for i = amin ( times_A + times_B ) to amax ( times_A + times_B ) collect i



/*  */ 
RigFlipper = RigFlipper_v()

--RigFlipper.mirrorTrasformsAtTimes obj_A times_A obj_B times_B

--RigFlipper.mirrorTrasformsAtTimes selection[1] times_A selection[2] times_8
RigFlipper.mirrorTrasformsAtTimes selection[1] times_all selection[2] times_all

