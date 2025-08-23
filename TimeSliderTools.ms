clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"

/* SETUP */
frame_buttons = 15
across = frame_buttons + 1


width_GroupBox1 = 196
width_button	= 36
--width_slider	= (width_button * frame_buttons) - 12
slider_pos_fix = 6
width_slider	= (width_button * frame_buttons) + ( width_button / 2) + slider_pos_fix
--width_slider	= ((width_button + 2) * frame_buttons ) 



/* DIALOG */
--Dialog 	    = Dialog_v ("Test") height:1024
Dialog 	    = Dialog_v ("Test") --ini:(getSourceFileName())

/* DIALOG CONTROLS */  
_Controls   = Dialog.Controls height:256
--_Button      = _Controls.control #button "Btn" 
--
--_Controls2   = Dialog.Controls group:("Main Controls2 " )
--_Button      = _Controls2.control #button "Btn 2" 


_GroupBox1 = _Controls.control #GroupBox "" params:#( #height, 196 ) across:across width:width_GroupBox1 id:#groupbox_name
--_GroupBox1 = _Controls.control #GroupBox "groupbox_nameX" params:#( #height, 196 ) across:2

pos_x_ini = width_GroupBox1 + 16
pos_y_ini = 8
pos_x = pos_x_ini

_Button = _Controls.control #button "0"	id:#btn_range_start	width:width_button pos:[ pos_x, pos_y_ini ]
_Slider = _Controls.control #SLIDER ""	id:#slider_current_time	width:width_slider pos:[ pos_x += width_button - slider_pos_fix , pos_y_ini ] range:[0, frame_buttons, 0] type:#integer  ticks:frame_buttons
_Button = _Controls.control #button "1"	id:#btn_range_end	width:width_button pos:[ pos_x += width_slider, pos_y_ini ]

pos_y_ini += width_button

pos_x_button =  pos_x_ini - ( width_button / 2 )


--for i = 0 to frame_buttons do
--	_Button = _Controls.control #button ( i as string ) 	width:width_button height:width_button pos:[ pos_x_button += width_button , pos_y_ini ] 

	--offset:[ width_GroupBox1 - width_button, 0]



for i = 1 to 3 do
	_Button = _Controls.control #button ("Box " + " " + i as string ) groupbox:"groupbox_name"


--
--/* ROLLOUTS */
--_Rollouts	 = Dialog.Rollouts()
--
--/* ROLLOUT */
--_Rollout    = _Rollouts.Roll "Subrollout"

--_Controls   = _Rollout.Controls group:"Rollout Controls"
--_Button     = _Controls.control #button "Rollout" id:#button_2


--
--/* SUBROLLOUTS */
--Subrollouts = _Rollout.Rollouts()
--
--/* SUBROLLOUT */
--_Subrollout = Subrollouts.Roll "Nested"
--_Controls    = _Subrollout.Controls group:"Subrollout Controls"
--_Button      = _Controls.control #button "Subrollout" id:#button_3
--
--
--/* DIALOG BOTTOM */
--_Controls   = Dialog.Controls group:"Main Controls Bottom"
--_Button     = _Controls.control #button "Bottom" id:#button_4


/* DIALOG CREATE */
--Dialog.create()
Dialog.create width:( width_GroupBox1 * 1.5 + ( width_button * across ) )
