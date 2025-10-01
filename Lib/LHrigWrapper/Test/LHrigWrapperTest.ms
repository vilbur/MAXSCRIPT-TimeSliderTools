clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./../../ObjectControllerKeys/ObjectControllerKeys.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../KeyFrameManager/KeyFrameManager.ms" )	--"./../../KeyFrameManager/KeyFrameManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../LHrigWrapper.ms" )	--"./../LHrigWrapper.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../TrasformsOnTimeManager/TrasformsOnTimeManager.ms" )	--"./../../TrasformsOnTimeManager/TrasformsOnTimeManager.ms"

LHrigWrapper = LHrigWrapper_v()
TrasformsOnTimeManager = TrasformsOnTimeManager_v()

rig_controls = LHrigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G


TrasformsOnTimeManager.mirrorPhases (rig_controls) ( Interval 1 3 )