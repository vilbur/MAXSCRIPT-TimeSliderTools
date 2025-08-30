clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"

filein( getFilenamePath(getSourceFileName()) + "/TimeSliderToolsDialog.ms" )	--"./TimeSliderToolsDialog.ms"



/** Time slider tools
 */
struct TimeSliderTools_v
(
	/* construct */
	

	/* required */
	

	/* properties */
	

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "TimeSliderTools.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)


timeSliderToolsDialog()