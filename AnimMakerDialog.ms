

/** Load content and create dialog
 */
function createAnimMakerDialog =
(
	--format "\n"; print ".loadContentAndCreateDialog()"
	current_dir	= getFilenamePath(getSourceFileName())
	
	
	/* LOAD CONTENT FROM FOLDERS */
	ContentLoader	= ContentLoader_v path:(current_dir+"/content-AnimMaker") ini:( getSourceFileName()) --DEBUG:DEBUG
	--ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")
	
	ContentLoader.Dialog.title = "AnimMaker"

	/* CREATE UI */
	--ContentLoader.create() --width:512
	ContentLoader.create width:168
	
	
)
