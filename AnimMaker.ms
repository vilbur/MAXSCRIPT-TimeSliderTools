clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms"


filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./Lib/ObjectControllerKeys/ObjectControllerKeys.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/KeyFrameManager/KeyFrameManager.ms" )	--"./Lib/KeyFrameManager/KeyFrameManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/RigWrapper/RigWrapper.ms" )	--"./Lib/RigWrapper/RigWrapper.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/PhaseCreator/PhaseCreator.ms" )	--"./Lib/PhaseCreator/PhaseCreator.ms"


filein( getFilenamePath(getSourceFileName()) + "/AnimMakerDialog.ms" )	--"./AnimMakerDialog.ms"

	createAnimMakerDialog()
