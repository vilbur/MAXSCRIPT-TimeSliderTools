filein( getFilenamePath(getSourceFileName()) + "/../TransformFlipper/TransformFlipper.ms" )	--"./../TransformFlipper/TransformFlipper.ms"
filein( getFilenamePath(getSourceFileName()) + "/LeftRightControls/LeftRightControls.ms" )	--"./LeftRightControls/LeftRightControls.ms"
/**
 */
struct RigWrapper_v
(
	/* construct */
	rig_name, --string rig_name E.G.: "Boy" | $Boy_Setup_Ctrl_MasterControl_G

	/* properties */
	rig_controls,
	
	key_times, -- #( int ) -- times to flip
	
	rx = ( dotNetClass "System.Text.RegularExpressions.RegEx" ),
	
	TransformFlipper = TransformFlipper_v(),

	control_name_pattern = "(.*_Setup_Ctrl_([^_]+_)).*",
	
	/** Load rig
	 */
	function loadRig =
	(
		--format "\n"; print "RigWrapper_v.loadRig()"
		
		master_control = this.loadRigFromScene(rig_name)
		
		processed_objects = #()

		this.rig_controls	= Dictionary #STRING -- KEY: VALUE:
		
		rig_name = (filterString master_control.name "_")[1]	
		
		rig_objs = execute ("$'"+ rig_name +"_Setup_Ctrl_*'") as Array
		
		for rig_obj in rig_objs where findItem processed_objects rig_obj == 0 do
		(
			/* ANALIZE OBJ NAME */ 
			split_name = this.splitName rig_obj.name
			basename   = split_name[2]
			side       = split_name[3]
			
			
			/* GET OBJ NMAE PATTERN */ 
			full_basename = rig_name +"_Setup_Ctrl_"+basename -- E.G.: "boy_Setup_Ctrl_IKFoot"

			
			/* GET OBJECTS WITH SAME PATTERN OF NAME  */ 
			same_name_objs = execute ("$'"+ full_basename +"_*'") as Array
			
			
			/* ADD CONTROL PAIR TO DICTIONARY */ 
			if same_name_objs.count == 2 and (side == "L" or side == "R") then
				rig_controls[full_basename] = (LeftRightControls_v()).addObjects(same_name_objs)(full_basename)

			
			/* AVOID PROCESSING OF SAME OBJECTS AGAIN  */ 
			processed_objects += same_name_objs
		)
		
		
		--format "rig_objs.count: %\n" rig_objs.count
		--format "rig_controls: %\n" rig_controls


		rig_controls --return
	),
	
	/** Mirror sifted phases
	  
		GET TRANSFROMS ON KEY TIMES OF BOTH OBJECTS
		FLIP ORINATATION OF TRANSFROMS
		SAVE FLIPPED TRANSFROMS TO SHIFTED KEYS ON OTHER SIDE OBJECT	  
		
		@param dictionary rig_controls list of controls E.G.: rig_controls["boy_Setup_Ctrl_IKFoot"]["L|R"] = #()
		
		
	 */
	function mirrorPhase phase increment:undefined =
	(
		format "\n"; print "PhaseCreator_v.mirrorPhases()"
		
		if increment == undefined or increment as Number == undefined then
			increment = phase[2] - phase[1] + 1
		
		
		--phase = [ currentTime.frame as integer , currentTime.frame + 2 ]
		
		KeyFrameManager = KeyFrameManager_v time:phase

		all_ctrls = #()
		
		for control_name in rig_controls.keys do 
		(
			LeftRightControls = rig_controls[control_name]
			
			LeftRightControls.switchKeysOnTimes phase increment:increment
		)
	),
	
	/** Load rig from scene
	  
	  @params string rig_name E.G.: Boy > Boy_Setup_Ctrl_MasterControl_G
	 */
	function loadRigFromScene rig_name =
	(
		--format "\n"; print "RigWrapper_v.loadRigFromScene()"

		execute ("$'"+rig_name+"_Setup_Ctrl_MasterControl_G'")[1] --return
	),
	
	/** Search for rigs in scene
	 */
	function searchForRigsInScene =
	(
		--format "\n"; print "RigWrapper_v.searchForRigsInScene()"

		execute ("$'*_Setup_Ctrl_MasterControl_G'") as Array --return
	),
	
	/** Search for rigs in scene
	 */
	function getNamesOfRigsInScene =
	(
		--format "\n"; print "RigWrapper_v.searchForRigsInScene()"
		
		rig_masters = execute ("$'*_Setup_Ctrl_MasterControl_G'") as Array
		
		
		rig_names = for rig_master in rig_masters collect (filterString rig_master.name "_")[1]
		
		--format "rig_masters: %\n" rig_masters
		
		--#( "Boy" ) --return
		rig_names --return
	),
	

	private
	
	
	/**
	 */
	on create do
	(
		--format "\n"; print "RigWrapper.onCreate()"
		if rig_name != undefined then 
			this.loadRig(rig_name)
	)
)
